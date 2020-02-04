import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(33.783022, -118.112858); // coordinates to CSULB :)

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold
    (
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text("Navigation Page"),
        backgroundColor: Colors.purple,
      ),
      body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.0,
          ),
        ),
    );
  }
}