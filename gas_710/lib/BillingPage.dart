import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_710/BillContactPage.dart';
import 'package:gas_710/LinkPaymentPage.dart';
import 'package:gas_710/main.dart';

class BillingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold
    (
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text("Billing Page"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(child: _cardListView(context)),
          ],
        ),
      ),
    );
  }

  Widget _cardListView(BuildContext context) {
    var contacts = [
    'Tyler Okonoma',
    'Kevin Abstract',
    'Hideo Kojima',
    'Norman Reedus',
    'Peter Parker',
    'Kobe Bryant',
    'Gianna Bryant',
    'Bart Simpson'
    ];

    var money = [
      5.23,
      -3.24,
      32.62,
      -13.79,
      0.01,
      24.00,
      2.00,
      -7.93
    ];

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return Card(
          // margin: EdgeInsets.all(8.0),
          elevation: 5,
          child: ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(
                contacts[index][0],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0
                ),
              ),
            ),
            title: Text(
              contacts[index],
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
            subtitle: Text(
              money[index].toString(),
              style: TextStyle(
                color: (money[index] > 0) ? Colors.black : Colors.red,
                fontSize: 15.0
              ),
            ),
            trailing: (money[index] > 0) ? _requestButton(context) :  _payButton(context),
            onTap: () {
              String contactName = contacts[index].toString();
              String dollars;
              if (money[index] > 0) {
                dollars = money[index].toString();
              } else {
                dollars = (-1 * money[index]).toString();
              }
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => BillContactPage(
                  name: contactName,
                  money: dollars)));
            },
            onLongPress: () {
              String contactName = contacts[index].toString();
              bool youOwe;
              String dollars;
              if (money[index] > 0) {
                youOwe = false;
                dollars = money[index].toString();
              } else {
                youOwe = true;
                dollars = (-1 * money[index]).toString();
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
}