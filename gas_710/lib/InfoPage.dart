import 'package:flutter/material.dart';
import 'package:gas_710/NavigationDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_710/auth.dart';

class InfoPage extends StatelessWidget {
  final userReference = signedIn
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
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                child: Text('Metrics', style: TextStyle(fontSize: 48.0)),
                alignment: Alignment.centerLeft,
              ),
            ),
            Divider(
              thickness: 2.5,
            ),
            StreamBuilder(
                stream: userReference.collection('trips').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.amber)),
                    );
                  Map<String, dynamic> values = getMetrics(snapshot);
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: <Widget>[
                            Text(
                              '${values['tripsTaken'].toInt()} ',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '- Trips taken',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: <Widget>[
                            Text(
                              '${values['averageCarpoolSize'].toStringAsFixed(2)} ',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '- Average carpool size',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: <Widget>[
                            Text(
                              '${values['totalPassengers'].toInt()} ',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '- Total passengers',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: <Widget>[
                            Text(
                              '${values['totalMiles']} ',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '- Total miles',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: <Widget>[
                            Text(
                              '${values['averageTripDistance'].toStringAsFixed(2)} ',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '- Average trip distance',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: <Widget>[
                            Text(
                              '${values['largestBill']} ',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '- Largest bill',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: <Widget>[
                            Text(
                              '${values['smallestBill']} ',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '- Smallest bill',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: <Widget>[
                            Text(
                              '${values['shortestTrip']} ',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '- Shortest trip (miles)',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: <Widget>[
                            Flexible(
                              child: Text(
                                '${values['shortestDestination']} ',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '- Shortest destination',
                                style: TextStyle(fontSize: 24.0),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: <Widget>[
                            Text(
                              '${values['longestTrip']} ',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '- Longest trip (miles)',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 8.0, 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: <Widget>[
                            Flexible(
                              child: Text(
                                '${values['longestDestination']} ',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '- Longest destination',
                                style: TextStyle(fontSize: 24.0),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  );
                }),
          ],
        ));
  }

  Map<String, dynamic> getMetrics(AsyncSnapshot<QuerySnapshot> snapshot) {
    double tripsTaken = snapshot.data.documents.length.toDouble();
    double averageCarpoolSize, averageTripDistance;
    double totalMiles = 0.0;
    double largestBill = 0.0;
    double smallestBill = snapshot.data.documents[0]['price'];
    double totalPassengers = 0.0;
    String longestDestination = "";
    double longestTrip = 0.0;
    String shortestDestination = snapshot.data.documents[0]['location'];
    double shortestTrip = snapshot.data.documents[0]['miles'];

    for (int i = 0; i < snapshot.data.documents.length; i++) {
      totalMiles += snapshot.data.documents[i]['miles'];
      totalPassengers += snapshot.data.documents[i]['passengers'].length;
      if (snapshot.data.documents[i]['price'] >= largestBill) {
        largestBill = snapshot.data.documents[i]['price'];
      }
      if (snapshot.data.documents[i]['price'] < smallestBill) {
        smallestBill = snapshot.data.documents[i]['price'];
      }
      if (snapshot.data.documents[i]['miles'] >= longestTrip) {
        longestTrip = snapshot.data.documents[i]['miles'];
        longestDestination = snapshot.data.documents[i]['location'];
      }
      if (snapshot.data.documents[i]['miles'] < shortestTrip) {
        shortestTrip = snapshot.data.documents[i]['miles'];
        shortestDestination = snapshot.data.documents[i]['location'];
      }
    }

    averageCarpoolSize = totalPassengers / tripsTaken;
    averageTripDistance = totalMiles / tripsTaken;

    Map<String, dynamic> values = {
      'tripsTaken': tripsTaken,
      'averageCarpoolSize': averageCarpoolSize,
      'totalPassengers': totalPassengers,
      'averageTripDistance': averageTripDistance,
      'totalMiles': totalMiles,
      'largestBill': largestBill,
      'smallestBill': smallestBill,
      'shortestTrip': shortestTrip,
      'shortestDestination': shortestDestination,
      'longestTrip': longestTrip,
      'longestDestination': longestDestination
    };

    return values;
  }
}
