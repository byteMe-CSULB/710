import 'package:flutter/material.dart';
import 'package:gas_710/NavigationDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_710/auth.dart';

class InfoPage extends StatelessWidget {
  final databaseReference = signedIn
      ? Firestore.instance.collection('userData').document(firebaseUser.email)
      : null;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: NavigationDrawer(), // provides nav drawer
        appBar: new AppBar(
          title: new Text("Info Page"),
          backgroundColor: Colors.purple,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                child: Text('Metrics', style: TextStyle(fontSize: 48.0)),
                alignment: Alignment.centerLeft,
              ),
            ),
            StreamBuilder(
                stream: databaseReference.collection('trips').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.amber));
                  Map<String, double> values = getData(snapshot);
                  return Card(
                    elevation: 5.0,
                    margin: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children:<Widget>[
                                Text(
                                  '${values['tripsTaken'].toInt()} ',
                                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '- Trips taken',
                                  style: TextStyle(fontSize: 24.0),
                                ),
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children:<Widget>[
                                Text(
                                  '${values['averageCarpoolSize']} ',
                                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '- Average carpool size',
                                  style: TextStyle(fontSize: 24.0),
                                ),
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children:<Widget>[
                                Text(
                                  '${values['totalMiles']} ',
                                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '- Total miles',
                                  style: TextStyle(fontSize: 24.0),
                                ),
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children:<Widget>[
                                Text(
                                  '${values['averageTripDistance']} ',
                                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '- Average trip distance',
                                  style: TextStyle(fontSize: 24.0),
                                ),
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children:<Widget>[
                                Text(
                                  '${values['largestBill']} ',
                                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '- Largest bill',
                                  style: TextStyle(fontSize: 24.0),
                                ),
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children:<Widget>[
                                Text(
                                  '${values['smallestBill']} ',
                                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '- Smallest bill',
                                  style: TextStyle(fontSize: 24.0),
                                ),
                              ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
          ],
        ));
  }
}

Map<String, double> getData(AsyncSnapshot<QuerySnapshot> snapshot) {
  double tripsTaken = snapshot.data.documents.length.toDouble();
  double averageCarpoolSize, averageTripDistance;
  double totalMiles = 0.0;
  double largestBill = 0.0;
  double smallestBill = snapshot.data.documents[0]['price'];
  double totalPassengers = 0.0;
  for (int i = 0; i < snapshot.data.documents.length; i++) {
    totalMiles += snapshot.data.documents[i]['miles'];
    totalPassengers += snapshot.data.documents[i]['passengers'].length;
    if (snapshot.data.documents[i]['price'] >= largestBill) {
      largestBill = snapshot.data.documents[i]['price'];
    }
    if (snapshot.data.documents[i]['price'] < smallestBill) {
      smallestBill = snapshot.data.documents[i]['price'];
    }
  }

  averageCarpoolSize = totalPassengers / tripsTaken;
  averageTripDistance = totalMiles / tripsTaken;

  Map<String, double> values = {
    'tripsTaken': tripsTaken,
    'averageCarpoolSize': averageCarpoolSize,
    'averageTripDistance': averageTripDistance,
    'totalMiles': totalMiles,
    'largestBill': largestBill,
    'smallestBill': smallestBill
  };

  return values;
}
