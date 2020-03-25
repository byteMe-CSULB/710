import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gas_710/main.dart';
import 'package:gas_710/auth.dart';
import 'package:gas_710/AccountPage.dart';

enum PaymentServices {paypal, gpay, cashapp, venmo, zelle}
PaymentServices prefService = PaymentServices.paypal;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold
    (
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text("Settings Page"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preferred Payment Services',
                style: TextStyle(
                  fontSize: 24
                )
              ),
            ),
            ListTile(
              title: const Text('PayPal'),
              leading: Radio(
                value: PaymentServices.paypal,
                groupValue: prefService,
                onChanged: (PaymentServices value) {
                  setState(() {
                    prefService = value;
                  });
                }
              )
            ),
            ListTile(
              title: const Text('Google Pay'),
              leading: Radio(
                value: PaymentServices.gpay,
                groupValue: prefService,
                onChanged: (PaymentServices value) {
                  setState(() {
                    prefService = value;
                  });
                }
              )
            ),
            ListTile(
              title: const Text('Cash App'),
              leading: Radio(
                value: PaymentServices.cashapp,
                groupValue: prefService,
                onChanged: (PaymentServices value) {
                  setState(() {
                    prefService = value;
                  });
                }
              )
            ),
            ListTile(
              title: const Text('Venmo'),
              leading: Radio(
                value: PaymentServices.venmo,
                groupValue: prefService,
                onChanged: (PaymentServices value) {
                  setState(() {
                    prefService = value;
                  });
                }
              )
            ),
            ListTile(
              title: const Text('Zelle'),
              leading: Radio(
                value: PaymentServices.zelle,
                groupValue: prefService,
                onChanged: (PaymentServices value) {
                  setState(() {
                    prefService = value;
                  });
                }
              )
            ),
            Divider(),
            SizedBox(
              width: double.infinity,
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sign in Here!',
                style: TextStyle(
                  fontSize: 24
                )
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 10.0,
            ),
            _signInButton(), // log in with Google Button
          ],
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AccountPage();
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0), // asset image
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}