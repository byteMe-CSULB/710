import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
import 'package:gas_710/WebViewPage.dart';

class LinkPaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text("Link Payment Page"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Open Google Pay'),
              onPressed: () {
                print('Opening Google Pay');
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WebViewPage(
                    title: "Google Pay",
                    selectedUrl: "https://pay.google.com",
                )));
              }
            ),
            RaisedButton(
              child: Text('Open PayPal'),
              onPressed: () {
                print('Opening PayPal');
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WebViewPage(
                    title: "PayPal",
                    selectedUrl: "https://www.paypal.com/us/home",
                )));
              }
            ),
          ],
        ),
      ),
    );
  }
}