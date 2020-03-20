import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:gas_710/AddPassengersPage.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';

double CAMERA_ZOOM = 13;
double CAMERA_TILT = 0;
double CAMERA_BEARING = 0;
LatLng SOURCE_LOCATION = LatLng(33.783022, -118.112858); // CSULB :)
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
  bool _locationSearched = false;
  bool _milesGot = false;
  bool calculationMade = false;

  // distance
  double miles = 0.0;

  double latitude = 0.0;
  double longitude = 0.0;

  double cost = 0.0;
  double costPerPassenger = 0.0;
  double gas = 0.0;
  String state = "";

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
    getStateLocation();
    _getInitLocation();
    setGas();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/location_pin.png');
  }

  void getStateLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    var currentState = await _getState(currentLocation);
    state = currentState.toString(); // sets state to current state 
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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

  _getInitLocation() async {
    var currentLocation = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    await _moveToPosition(currentLocation);
  }

  PanelController _pc = new PanelController();

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
      body: SlidingUpPanel(
        controller: _pc,
        borderRadius: radius,
        minHeight: 70,
        backdropTapClosesPanel: true,
        backdropEnabled: true,
        backdropOpacity: 0.3,
        parallaxEnabled: true,
        panel: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'Add Passengers',
                                style: TextStyle(
                                  fontSize: 23.0,
                                ),
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.location_on),
                                  onPressed: () {
                                    if(_pc.isAttached) {
                                      if(_pc.isPanelOpen) {
                                        _pc.close();
                                        _getLocation();
                                      } else {
                                        _getLocation();
                                      }
                                    }
                                  },
                                  tooltip: "Get Your Current Location",
                                  iconSize: 36,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  shape: BoxShape.circle
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.group_add),
                                  onPressed: () {
                                    if(_pc.isAttached) {
                                      if(_pc.isPanelClosed) {
                                        _pc.open();
                                        _getPassengers(context);
                                      } else {
                                        _getPassengers(context);
                                      }
                                    }
                                  },
                                  tooltip: "Add Passengers to a Trip",
                                  iconSize: 36,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: ListView.builder(
                              itemCount: contacts.length,
                              itemBuilder: (BuildContext context, int index) =>
                                Card(
                                  elevation: 4.0,
                                  child: ListTile(
                                    leading: (contacts[index].avatar != null &&
                                          contacts[index].avatar.length > 0)
                                      ? CircleAvatar(
                                          backgroundImage:
                                              MemoryImage(contacts[index].avatar),
                                          maxRadius: 30,)
                                      : CircleAvatar(
                                          child: Text(contacts[index].initials(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 36,
                                            )
                                          ),
                                          backgroundColor: Colors.purple,
                                          maxRadius: 30,
                                        ),
                                      title: Text(
                                        contacts[index].displayName,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      subtitle: Text(
                                        contacts[index].phones.first.value.toString()
                                      ),
                                      trailing: Text((index + 1).toString()),
                                  ),
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
                    padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
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
                              'Total Miles: $miles',
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
                              'Cost Per Passenger: $costPerPassenger',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey[700],
                              ),
                            )
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Total Cost: $cost',
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
                    color: passengers > 0 ? Colors.amber : Colors.grey[400],
                    child: Text(
                      "Confirm Passengers",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: confirmPassengerButtonPress,
                  ),
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
            top: 30.0,
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
                      apiKey: googlePlacesAPIKey,
                  );
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
                  //closes keyboard
                  FocusScope.of(context).requestFocus(new FocusNode());
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
      if(miles > 0) {
        setCost();
        setCostPP();
      }
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

  Future<String> _getState(Position pos) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      print(pos.administrativeArea);
      return pos.administrativeArea;
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
    setState((){
      if (passengerResult != null) {
        contacts = passengerResult;
        passengers = passengerResult.length;
        if(miles > 0) {
          setCost();
          setCostPP();
        }
      }
    });
  }

  //when Confirm Passengers button gets pressed
  confirmPassengerButtonPress() {
    if (contacts.length > 0 && _milesGot && _locationSearched) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new TripSummaryPage(
                  selected: contacts,
                  location: searchAddr,
                  miles: miles,
                  lat: latitude,
                  long: longitude,
                  costPerPassenger: (cost/passengers),
                  totalCost: cost)));
    } else {
      if (contacts.length <= 0 && !_milesGot && !_locationSearched) {
        Fluttertoast.showToast(
          msg: 'No passengers or destination set',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 16.0,
        );
      } else if (contacts.length <= 0) {
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
  }

  setGas() async {
    // TODO: change collection to 'costPerState' when updated in Firebase
    var query = Firestore.instance.collection('costPerSate').where('location', isEqualTo: 'California').getDocuments();
    query.then((value) => gas = double.parse(value.documents[0]['ppg'].toString().substring(1)));
  }

  setCost() {
    setState(() {
      int fuelEfficiency = 20; // let's just assume someone has an OK car mpg
      print('Gas: $gas Miles: $miles');
      double tempCost= ((miles * gas) / fuelEfficiency);
      cost = double.parse(tempCost.toStringAsFixed(2));
      print('Cost: $cost');
      calculationMade = true;
    });
  }

  setCostPP() {
    String temp = (cost / passengers).toStringAsFixed(2);
    setState(() {
      costPerPassenger = double.parse(temp);
    });
  }
}
