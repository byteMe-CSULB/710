import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_710/BillContactPage.dart';
import 'package:gas_710/LinkPaymentPage.dart';
// import 'package:gas_710/TestPage.dart';
import 'package:gas_710/main.dart';
import 'package:gas_710/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class BillingPage extends StatelessWidget {
  final databaseReference = signedIn ? Firestore.instance.collection('userData').document(firebaseUser.email) : null;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text("Billing Page"),
        backgroundColor: Colors.purple,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.exit_to_app),
        //     onPressed: () {                  
        //       Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage()));
        //     } 
        //   ),
        // ],
      ),
      body: signedIn ? StreamBuilder(
        stream: databaseReference.collection('contacts').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return CircularProgressIndicator();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(child: _listView(snapshot)),
              ],
            ),
          );
        }
      ) : _signedOut(context)
    );
  }

  _listView(AsyncSnapshot<QuerySnapshot> snapshot) { 
    var money = [];
    for(int i = 0; i < snapshot.data.documents.length; i++) {
      money.add(randomMoney());
    }
    return ListView.builder(
      itemCount: snapshot.data.documents.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          child: ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: (Uint8List.fromList(snapshot.data.documents[index]['avatar'].codeUnits) != null && 
            Uint8List.fromList(snapshot.data.documents[index]['avatar'].codeUnits).length > 0)
                        ? CircleAvatar(backgroundImage: MemoryImage(Uint8List.fromList(snapshot.data.documents[index]['avatar'].codeUnits)))
                        : CircleAvatar(child: 
                        Text(
                          snapshot.data.documents[index]['displayName'][0],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0
                          ),
                        ),
                        backgroundColor: Colors.purple),
            title: Text(
              snapshot.data.documents[index]['displayName'],
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
            subtitle: Text(
              money[index].toStringAsFixed(2),
              style: TextStyle(
                color: (money[index] > 0) ? Colors.black : Colors.red,
                fontSize: 15.0
              ),
            ),
            trailing: (money[index] > 0) ? _requestButton(context) :  _payButton(context),
            onTap: () {
              String contactName = snapshot.data.documents[index]['displayName'];
              String dollars;
              if (money[index] > 0) {
                dollars = money[index].toStringAsFixed(2);
              } else {
                dollars = (-1 * money[index]).toStringAsFixed(2);
              }
              Uint8List avatar = Uint8List.fromList(snapshot.data.documents[index]['avatar'].codeUnits);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => BillContactPage(
                  name: contactName,
                  money: dollars,
                  avatar: avatar)));
            },
            onLongPress: () {
              String contactName = snapshot.data.documents[index]['displayName'].toString();
              bool youOwe;
              String dollars;
              if (money[index] > 0) {
                youOwe = false;
                dollars = money[index].toStringAsFixed(2);
              } else {
                youOwe = true;
                dollars = (-1 * money[index]).toStringAsFixed(2);
              }
              Fluttertoast.showToast(
                msg: youOwe ? 'You owe $contactName \$$dollars' : '$contactName owes you \$$dollars',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                fontSize: 16.0,
              );
            }
          ),
        );
      }
    );
  }

  Widget _requestButton(BuildContext context) {
    return RaisedButton(
      child: Text(
        'Request'
      ),
      shape: StadiumBorder(),
      color: Colors.amber,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LinkPaymentPage()));
      },
    );
  }

  Widget _payButton(BuildContext context) {
    return RaisedButton(
      child: Text(
        'Pay'
      ),
      shape: StadiumBorder(),
      color: Colors.amber,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LinkPaymentPage()));
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

  double randomMoney() { // this is just for money placeholders, definitely remove later
    Random random = Random();
    double rngDecimal = random.nextInt(20).toDouble();
    rngDecimal += random.nextDouble();
    var oweOrOwed = random.nextInt(2);
    if(oweOrOwed == 0) {
      return rngDecimal;
    } else return rngDecimal * -1;
  }
}