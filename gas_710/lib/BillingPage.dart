import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_710/BillContactPage.dart';
import 'package:gas_710/BillingPassengersPage.dart';
import 'package:gas_710/WebViewPage.dart';
import 'package:gas_710/NavigationDrawer.dart';
import 'package:gas_710/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_710/SettingsPage.dart';
import 'package:flutter_sms/flutter_sms_platform.dart';
import 'package:intl/intl.dart';

class BillingPage extends StatefulWidget {
  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  // TODO: modify defaultTextMessage string
  String defaultTextMessage =
      "This is a default test message! Cost: \$"; // Default text message
  List<String> recipentsPhoneNumber = []; // List of phone numbers to text
  DateTime tripDateTime;
  final databaseReference = signedIn
      ? Firestore.instance.collection('userData').document(firebaseUser.email)
      : null;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: NavigationDrawer(), // provides nav drawer
        appBar: new AppBar(
          title: new Text("Billing Page"),
          backgroundColor: Colors.purple,
        ),
        body: signedIn
            ? StreamBuilder(
                //Get trips from firebase
                stream: databaseReference
                    .collection('trips')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.amber)));
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(child: _listView(snapshot)),
                      ],
                    ),
                  );
                })
            : _signedOut(context));
  }

  _listView(AsyncSnapshot<QuerySnapshot> snapshot) {
    var dates = [];
    for (int i = 0; i < snapshot.data.documents.length; i++) {
      DateTime myDateTime = snapshot.data.documents[i]['date'].toDate();
      dates.add(DateFormat.yMMMMd().format(myDateTime).toString() +
          " " +
          DateFormat("h:mm a").format(myDateTime).toString());
    }
    return ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.all(8.0),
              title: Text(
                snapshot.data.documents[index]['location'].toString(),
                style: TextStyle(fontSize: 18.0),
              ),
              subtitle: Text(
                "Passengers: " +
                    snapshot.data.documents[index]['passengers'].length
                        .toString() +
                    "\nDater: " +
                    dates[index],
                style: TextStyle(fontSize: 12.0),
              ),
              onTap: () {
                // Get passenger names
                List<dynamic> passengerList =
                    snapshot.data.documents[index]['passengers'];
                // Get price owed from passengers
                HashMap priceOwedPassengerList =
                    new HashMap<String, dynamic>.from(
                        snapshot.data.documents[index]['passengersOwed']);
                //Remove the text 'Delete' in their name
                for (int i = 0; i < passengerList.length; i++) {
                  if (passengerList[i].toString().contains('(Deleted')) {
                    passengerList[i] = passengerList[i]
                        .toString()
                        .substring(0, passengerList[i].toString().length - 9);
                  }
                }
                String tripLocation =
                    snapshot.data.documents[index]['location'].toString();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BillingPassengersPage(
                              passengerList: passengerList,
                              priceOwedPassengerList: priceOwedPassengerList,
                              tripLocation: tripLocation,
                            )));
              },
            ),
          );
        });
  }

  Widget _requestButton(BuildContext context) {
    return RaisedButton(
      child: Text('Request'),
      shape: StadiumBorder(),
      color: Colors.amber,
      onPressed: () {
        if (prefService == PaymentServices.gpay) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WebViewPage(
                    title: "Google Pay",
                    selectedUrl: "https://pay.google.com",
                  )));
        } else if (prefService == PaymentServices.paypal) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WebViewPage(
                    title: "PayPal",
                    selectedUrl: "https://www.paypal.com/us/home",
                  )));
        } else if (prefService == PaymentServices.cashapp) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WebViewPage(
                    title: "CashApp",
                    selectedUrl: "https://cash.app/",
                  )));
        } else if (prefService == PaymentServices.venmo) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WebViewPage(
                    title: "Venmo",
                    selectedUrl: "https://venmo.com/",
                  )));
        } else if (prefService == PaymentServices.zelle) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WebViewPage(
                    title: "Zelle",
                    selectedUrl: "https://www.zellepay.com/",
                  )));
        }
      },
    );
  }

  Widget _payButton(BuildContext context) {
    return RaisedButton(
      child: Text('Pay'),
      shape: StadiumBorder(),
      color: Colors.amber,
      onPressed: () {
        if (prefService == PaymentServices.gpay) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WebViewPage(
                    title: "Google Pay",
                    selectedUrl: "https://pay.google.com",
                  )));
        } else if (prefService == PaymentServices.paypal) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WebViewPage(
                    title: "PayPal",
                    selectedUrl: "https://www.paypal.com/us/home",
                  )));
        } else if (prefService == PaymentServices.cashapp) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WebViewPage(
                    title: "CashApp",
                    selectedUrl: "https://cash.app/",
                  )));
        } else if (prefService == PaymentServices.venmo) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WebViewPage(
                    title: "Venmo",
                    selectedUrl: "https://venmo.com/",
                  )));
        } else if (prefService == PaymentServices.zelle) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WebViewPage(
                    title: "Zelle",
                    selectedUrl: "https://www.zellepay.com/",
                  )));
        }
      },
    );
  }

  Widget _signedOut(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'That can\'t be right..?\nSign in to see your bills!',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _textButton(BuildContext context, String personName,
      String phoneNumber, double bill) {
    return IconButton(
      icon: Icon(Icons.textsms),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildTextingDialog(context, personName, phoneNumber, bill),
        );
      },
    );
  }

  Widget _buildTextingDialog(BuildContext context, String personName,
      String phoneNumber, double bill) {
    return new AlertDialog(
      title: new Text("Text $personName"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text("Pressing \'Okay\' will send you to the texting app. \n"),
          new Text("Phone Number: $phoneNumber \n"),
          new Text("Message: $defaultTextMessage $bill"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.red,
          child: const Text('Cancel'),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            //Add their phone in the list
            recipentsPhoneNumber.add(phoneNumber);
            // Open message app
            _sendSMS(
                defaultTextMessage + bill.toString(), recipentsPhoneNumber);
            recipentsPhoneNumber.clear();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Okay'),
        ),
      ],
    );
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await FlutterSmsPlatform.instance
        .sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}
