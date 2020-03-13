import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
import 'package:gas_710/NavigationPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:gas_710/auth.dart';


class TripSummaryPage extends StatelessWidget {
  final List<Contact> selected;
  final miles, location, lat, long;
  TripSummaryPage(
      {Key key,
      @required this.selected,
      @required this.location,
      @required this.miles,
      @required this.lat,
      @required this.long})
      : super(key: key);

  final databaseReference = Firestore.instance;

  final noPhoneError = "NO PHONE NUMBER PROVIDED";
  final noEmailError = "NO EMAIL PROVIDED";
  
  static Future<void> openMap(String location) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$location';
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
              leading: Icon(Icons.directions, size: 60.0),
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
                  separatorBuilder: (context, index) => SizedBox(
                    width: 5.0,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: selected.length,
                  itemBuilder: (BuildContext context, int index) => Chip(
                    label: Text(selected[index].displayName,
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context); 
                    },
                    child: Text(
                      'Cancel'
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if(signedIn) {
                        addTrip();
                        addContact();
                        openMap(location);
                      } else {
                        showAlertDialog(context);
                      }
                    },
                    child: Text(
                      'Open GoogleMaps'
                    ),
                    color: Colors.amber
                  ),
                ],
              ),
            ],
        ))));
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('Warning'),
      content: Text('Your Trips Will Not Be Saved Unless You Are Signed In. \n\nPlease Check Settings.'),
      actions: <Widget>[
        FlatButton(
          child: Text('Open GoogleMaps'),
          onPressed: () {
            openMap(location);
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      }
    );
  }

  void addTrip() async { // this is different from addPassengers() bc this one stores all passengers in one
    var userReference = databaseReference.collection('userData').document(firebaseUser.email);
    print('addTrip: selected.length = ${selected.length}');
    var passengers = [];
    for(int i = 0; i < selected.length; i++) {
      passengers.add(selected[i].displayName);
    }
    print('addTrip: Sending $passengers to Firebase');
    await userReference.collection("trips")
      .add({
        'passengers' : passengers,
        'miles' : miles,
        'location' : location,
        'date' : DateTime.now(),
        'price' : 200.00,
        'route' : GeoPoint(lat, long)
      });
  }

  void addContact() async { // we add per individual
    var userReference = databaseReference.collection('userData').document(firebaseUser.email);
    var test = await userReference.collection('userData').document(firebaseUser.email).collection('contacts').getDocuments();
    if(test.documents.length == 0) { // no collection created.
      userReference.collection('contacts').document('init').setData({
        'displayName' : 'init',
        'emailAddress' : 'int',
        'phoneNumber' : 'int'
      });
    }
    for(int i = 0; i < selected.length; i++) {
      var query = 
        await userReference.collection('contacts').where('displayName', isEqualTo: selected[i].displayName).getDocuments();
      if(query.documents.length == 0) {
        String emails, phoneNumbers = '';
        if(selected[i].emails.isNotEmpty) {
          emails = selected[i].emails.first.value.toString();
        } else {
          emails = noEmailError;
        }
        if(selected[i].phones.isNotEmpty) {
          phoneNumbers = selected[i].phones.first.value.toString();
        } else {
          phoneNumbers = noPhoneError;
        }
        print('addContacts: Sending ${selected[i].displayName} - $emails - $phoneNumbers');
        await userReference.collection("contacts")
          .add({
            'displayName' : selected[i].displayName,
            'emailAddress' : emails,
            'phoneNumber' : phoneNumbers,
        });
        userReference.collection('contacts').document('init').delete();
      }
    }
  }
}
