import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
////////////////////////////////////////////////////////////////////////////
/*          TAYLOR TESTING MAPS */
class MapTest extends StatefulWidget {
  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState  extends State<MapTest> {

  GoogleMapController mapController;

  final LatLng _center = const LatLng(33.840763, -118.345413);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: new DrawerCodeOnly(), // provides nav drawer
        appBar: new AppBar(
          title: Text('710 Test lololool'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
/*          TAYLOR TESTING MAPS */
//////////////////////////////////////////////////////////////////////////////