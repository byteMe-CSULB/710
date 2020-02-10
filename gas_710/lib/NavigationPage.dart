import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(33.783022, -118.112858); // CSULB :)
const LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  Completer<GoogleMapController> _controller = Completer();

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

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/location_pin.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    // setMapPins();
    // setPolylines();
  }

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print('got current location as ${currentLocation.latitude}, ${currentLocation.longitude}');    
    var currentAddress = await _getAddress(currentLocation);    
    await _moveToPosition(currentLocation);

    setState(() {
      // _markers.clear();
      // final marker = Marker(
      //     markerId: MarkerId("curr_loc"),
      //     position: LatLng(currentLocation.latitude, currentLocation.longitude),
      //     infoWindow: InfoWindow(title: currentAddress),
      // );
      // _markers.add("Current Location") = marker;
      // // source pin
      //   _markers.add(Marker(
      //       markerId: MarkerId('sourcePin'),
      //       position: SOURCE_LOCATION,
      //       icon: sourceIcon)); 
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow:  InfoWindow(title: currentAddress),
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

    return new Scaffold
    (
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text("Navigation Page"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        backgroundColor: Colors.amber,
        child: Icon(Icons.location_on),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            tiltGesturesEnabled: false,
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
        ]
      ),
    );
  }

  Future<void> animateTo(double lat, double long) async {
    final c = await _controller.future;
    final p = CameraPosition(target: LatLng(lat, long), zoom: 15.0);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) async { // result is your destination that searched from searchAddr
      animateTo(result[0].position.latitude, result[0].position.longitude); // takes us to the location
      var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best); // pings YOUR location
      double distanceInMeter = await Geolocator().distanceBetween(currentLocation.latitude, currentLocation.longitude, result[0].position.latitude, result[0].position.longitude);
      print("Distance to $searchAddr is $distanceInMeter meters from your location");
      setMapPins(currentLocation.latitude, currentLocation.longitude, result[0].position.latitude, result[0].position.longitude);
      setPolylines(currentLocation.latitude, currentLocation.longitude, result[0].position.latitude, result[0].position.longitude);
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
    if(_controller == null) return;
    print('moving to position ${pos.latitude}, ${pos.longitude}');
    animateTo(pos.latitude, pos.longitude);
  }

  void setMapPins(double sourceLat, double sourceLong, double destLat, double destLong) async {
      double distanceInMeter = await Geolocator().distanceBetween(sourceLat, sourceLong, destLat, destLong);
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

  setPolylines(double sourceLat, double sourceLong, double destLat, double destLong) async {
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        sourceLat,
        sourceLong,
        destLat,
        destLong);
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
}