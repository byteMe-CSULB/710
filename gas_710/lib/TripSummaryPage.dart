import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
import 'package:gas_710/NavigationPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripSummaryPage extends StatelessWidget {
  final selected, miles, location, lat, long;
  TripSummaryPage({Key key, @required this.selected, @required this.location,
   @required this.miles, @required this.lat, @required this.long}) : super(key : key);

  final databaseReference = Firestore.instance;

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text("Trip Summary Page"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.directions,
                  size: 60.0
                ),
                title: Text(
                  'Your Trip',
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                subtitle: Text(
                  '$miles miles to $location',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                child: ListView.separated(
                  separatorBuilder: (context, index) => 
                    SizedBox(
                      width: 5.0,
                    ),
                  scrollDirection: Axis.horizontal,
                  itemCount: selected.length,
                  itemBuilder: (BuildContext context, int index) =>
                    Chip(
                      label: Text(
                        selected[index],
                        style: TextStyle(color: Colors.black)
                      ),
                    ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => new NavigationPage()));
                    },
                    child: Text(
                      'Cancel'
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      addTrip();
                      addContact();
                      openMap(lat, long);
                    },
                    child: Text(
                      'Open GoogleMaps'
                    ),
                    color: Colors.amber
                  ),
                ],
              ),
            ],
          )
        )
      )
    );
  }

  void addTrip() async { // this is different from addPassengers() bc this one stores all passengers in one
    var now = DateTime.now();
    print('DateTime.now() = $now');
    DocumentReference ref = await databaseReference.collection("trip")
      .add({
        'passengers' : selected,
        'miles' : miles,
        'location' : location,
        'date' : now,
        'price' : 200.00,
      });
  }

  void addContact() async { // we add per individual, beware of duplicate names!!!
    await databaseReference.collection("recentContacts")
        .document("contactNames")
        .updateData({
          'name' : FieldValue.arrayUnion(selected),
        });
  }
}