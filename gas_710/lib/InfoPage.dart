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
        body: StreamBuilder(
          stream: userReference.collection('trips').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.amber)
                ),
              );
            Map<String, dynamic> values = getMetrics(snapshot);
            return GridView.count(
              crossAxisCount: 2,
              children: <Widget>[
                metricContainer('Trips Taken', values['tripsTaken'].toString()),
                metricContainer('Average Carpool Size', values['averageCarpoolSize'].toStringAsFixed(2)),
                metricContainer('Total Passengers', values['totalPassengers'].toString()),
                metricContainer('Total Miles', values['totalMiles'].toStringAsFixed(2)),
                metricContainer('Average Trip Distance', values['averageTripDistance'].toStringAsFixed(2)),
                metricContainer('Largest Bill', '\$${values['largestBill'].toString()}'),
                metricContainer('Smallest Bill', '\$${values['smallestBill'].toString()}'),
                metricContainer('Shortest Trip', values['shortestTrip'].toStringAsFixed(2) + ' miles'),
                metricContainer('Shortest Destination', values['shortestDestination']),
                metricContainer('Longest Trip', values['longestTrip'].toStringAsFixed(2) + ' miles'),
                metricContainer('Longest Destination', values['longestDestination'])
              ],
            );
          }
        )
    );
  }

  Widget metricContainer(String title, String msg) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 32.0,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  msg,
                  style: TextStyle(
                    fontSize: 42.0,
                    fontStyle: FontStyle.italic
                  ),
                  softWrap: true,
                ),
              ),
            ),
          )
        ],
      ),
    );
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
