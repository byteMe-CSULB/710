import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:gas_710/AddPassengersPage.dart';
import 'package:gas_710/ContactsPage.dart';
import 'package:gas_710/InfoPage.dart';
import 'package:gas_710/main.dart';
import 'package:gas_710/TripSummaryPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:contacts_service/contacts_service.dart';

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(33.783022, -118.112858); // CSULB :)
const LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);
const googlePlacesAPIKey = "AIzaSyD71HMbuRIt7smNaNek_R0OXBRHJMtj_fo";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googlePlacesAPIKey);

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _textController = new TextEditingController();

  // this set will hold my markers
  Set<Marker> _markers = {};

  // this will hold the generated polylines
  Set<Polyline> _polylines = {};

  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];

  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPIKey = "AIzaSyDX4p3BL6ceYnQma0S6vMCYQVRKD5P-JT4";

  // for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  // search address
  String searchAddr;

  // number of passengers
  int passengers = 0;

  // mock contact list
  List<Contact> contacts = new List<Contact>();
  var selected = [];
  var selectedContacts = new List<String>();
  bool _contactSelected = false;
  bool _locationSearched = false;
  bool _milesGot = false;

  // distance
  double miles = 0.0;

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/location_pin.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    // setMapPins();
    // setPolylines();
  }

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(
        'got current location as ${currentLocation.latitude}, ${currentLocation.longitude}');
    var currentAddress = await _getAddress(currentLocation);
    await _moveToPosition(currentLocation);

    setState(() {
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: currentAddress),
        icon: sourceIcon,
      );
      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: SOURCE_LOCATION);

    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return new Scaffold(
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text("Navigation Page"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 525.0),
        child: FloatingActionButton(
          onPressed: _getLocation,
          backgroundColor: Colors.amber,
          child: Icon(Icons.location_on),
        ),
      ),
      body: SlidingUpPanel(
        borderRadius: radius,
        minHeight: 60,
        panel: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                            child: Text(
                              'Add Passengers',
                              style: TextStyle(
                                fontSize: 23.0,
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: RaisedButton(
                                  color: Colors.white,
                                  child: Text(
                                    "Add Passengers",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    _getPassengers(context);
                                  },
                                ),
                              )),
                          Expanded(
                            child: Container(
                                child: ListView.builder(
                              itemCount: contacts.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  FilterChip(
                                // dynamically add contacts to trip
                                avatar: CircleAvatar(
                                  backgroundColor: Colors.grey[400],
                                  child: Text(
                                    contacts[index].displayName[0],
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                label: Text(contacts[index].displayName,
                                    style: TextStyle(color: Colors.black)),
                                showCheckmark: false,
                                onSelected: (bool value) {
                                  if (selected.contains(index)) {
                                    selected.remove(index);
                                    print('Removed ' +
                                        contacts[index].displayName);
                                    selectedContacts.remove(contacts[index]);
                                    passengers -= 1;
                                  } else {
                                    selected.add(index);
                                    print(
                                        'Added ' + contacts[index].displayName);
                                    selectedContacts
                                        .add(contacts[index].displayName);
                                    passengers += 1;
                                  }
                                  setState(() {
                                    if (selected.isNotEmpty) {
                                      _contactSelected = true;
                                    } else {
                                      _contactSelected = false;
                                    }
                                  });
                                },
                                selected: selected.contains(index),
                                selectedColor: Colors.amber,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.purple[300],
                              ),
                              scrollDirection: Axis.vertical,
                            )),
                          ),
                        ],
                      )),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Number of Passengers: $passengers',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.grey[700]),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              // !!! change to miles !!!
                              'Total Miles: $miles', // right now this is in meters OOPS
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.grey[700]),
                            ),
                          ),
                          Divider(
                            thickness: 0.8,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Total Cost: \$200', // hard coded price, figure this later
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: RaisedButton(
                      color: _contactSelected ? Colors.amber : Colors.grey[400],
                      child: Text(
                        "Confirm Passengers",
                        style: TextStyle(
                            color: _contactSelected
                                ? Colors.black
                                : Colors.blueGrey),
                      ),
                      onPressed: () {
                        if (_contactSelected &&
                            _milesGot &&
                            _locationSearched) {
                          print('Passing in $miles $searchAddr');
                          print('Contacts');
                          print(selectedContacts);
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new TripSummaryPage(
                                      selected: selectedContacts,
                                      location: searchAddr,
                                      miles: miles,
                                      lat: latitude,
                                      long: longitude)));
                        } else {
                          if (!_contactSelected &&
                              !_milesGot &&
                              !_locationSearched) {
                            Fluttertoast.showToast(
                              msg: 'No passengers or destination set',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              fontSize: 16.0,
                            );
                          } else if (!_contactSelected) {
                            Fluttertoast.showToast(
                              msg: 'No passengers selected',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              fontSize: 16.0,
                            );
                          } else if (!_milesGot || !_locationSearched) {
                            Fluttertoast.showToast(
                              msg: 'Destination not set',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              fontSize: 16.0,
                            );
                          }
                        }
                      }),
                ),
              )
            ],
          ),
        ),
        body: Stack(children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            tiltGesturesEnabled: false,
            compassEnabled: false,
            markers: _markers,
            polylines: _polylines,
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: initialLocation,
          ),
          Positioned(
            top: 20.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: TextField(
                readOnly: false,
                controller: _textController,
                // When user taps search bar, autocomplete comes up
                onTap: () async {
                  Prediction p = await PlacesAutocomplete.show(
                      context: context,
                      mode: Mode.overlay,
                      apiKey: googlePlacesAPIKey);
                  //if user picks an address, send it to the search bar
                  if (p != null) {
                    displayPrediction(p);
                    searchAddr = p.description;
                    _textController.value = TextEditingValue(
                      text: searchAddr,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: searchAddr.length),
                      ),
                    );
                    searchandNavigate();
                  }
                },
                //When user presses 'ok' on keyboard.
                onSubmitted: (String value) async {
                  searchandNavigate();
                },
                decoration: InputDecoration(
                  hintText: 'Enter Address..',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    iconSize: 30.0,
                    onPressed: searchandNavigate,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    searchAddr = val;
                  });
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  Future<void> animateTo(double lat, double long) async {
    final c = await _controller.future;
    final p = CameraPosition(target: LatLng(lat, long), zoom: 15.0);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  searchandNavigate() {
    _markers.clear(); // clears any previous search queries
    _polylines.clear();
    polylineCoordinates.clear();
    Geolocator().placemarkFromAddress(searchAddr).then((result) async {
      // result is your destination that searched from searchAddr
      animateTo(result[0].position.latitude,
          result[0].position.longitude); // takes us to the location
      var currentLocation = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best); // pings YOUR location
      double distanceInMeter = await Geolocator().distanceBetween(
          currentLocation.latitude,
          currentLocation.longitude,
          result[0].position.latitude,
          result[0].position.longitude);
      miles = convertMetersToMiles(distanceInMeter);
      _locationSearched = true;
      _milesGot = true;
      latitude = result[0].position.latitude;
      longitude = result[0].position.longitude;
      print(
          "Distance to $searchAddr is $distanceInMeter meters from your location");
      setMapPins(currentLocation.latitude, currentLocation.longitude,
          result[0].position.latitude, result[0].position.longitude);
      setPolylines(currentLocation.latitude, currentLocation.longitude,
          result[0].position.latitude, result[0].position.longitude);
    });
  }

  Future<String> _getAddress(Position pos) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      print(pos.thoroughfare + ', ' + pos.locality);
      return pos.thoroughfare + ', ' + pos.locality;
    }
    return "";
  }

  Future<void> _moveToPosition(Position pos) async {
    if (_controller == null) return;
    print('moving to position ${pos.latitude}, ${pos.longitude}');
    animateTo(pos.latitude, pos.longitude);
  }

  void setMapPins(double sourceLat, double sourceLong, double destLat,
      double destLong) async {
    double distanceInMeter = await Geolocator()
        .distanceBetween(sourceLat, sourceLong, destLat, destLong);
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: LatLng(sourceLat, sourceLong),
          icon: sourceIcon));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: LatLng(destLat, destLong),
          icon: destinationIcon,
          infoWindow: InfoWindow(
            title: "$distanceInMeter meters away",
          )));
    });
  }

  setPolylines(double sourceLat, double sourceLong, double destLat,
      double destLong) async {
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey, sourceLat, sourceLong, destLat, destLong);
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  double convertMetersToMiles(double m) {
    return double.parse((m * 0.00062137).toStringAsFixed(2));
  }

  //prints the autocomplete address
  //Can be scraped later if of no use
  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat.toString() + ", " + lng.toString() + ", " + p.description);
    }
  }

  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  //Return passengers data and set it to contacts variable
  _getPassengers(BuildContext context) async {
    List<Contact> passengerResult = new List<Contact>();

    passengerResult = await Navigator.push(context,
        new MaterialPageRoute(builder: (context) => AddPassengersPage()));
    if (passengerResult != null) {
      this.contacts = passengerResult;
    }
  }
}
