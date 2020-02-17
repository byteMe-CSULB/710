import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';

class LinkPaymentPage extends StatelessWidget {

  List<Application> apps;
  bool PayPalInstalled = false;
  bool GooglePayInstalled = false;

  // Get all installed apps
  getApps() async {
    this.apps = await DeviceApps.getInstalledApplications();
    apps.forEach((element) => print(element.packageName));
    this.PayPalInstalled = await DeviceApps.isAppInstalled('com.paypal.android.p2pmobile');
    this.GooglePayInstalled = await DeviceApps.isAppInstalled('com.google.android.apps.walletnfcrel');
    print("PayPal - True?:------ " + PayPalInstalled.toString() + "\n");
    print("GooglePay - True?:------ " + GooglePayInstalled.toString() + "\n");
  }

  // Launches webpage
  _launchURL() async {
    const url = 'https://www.paypal.com/us/home';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchGPayURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.google.android.apps.walletnfcrel&hl=en_US';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchPayPal() {
    // print("Inside launchPayPal: " + this.PayPalInstalled.toString());
    if (this.PayPalInstalled){
      DeviceApps.openApp('com.paypal.android.p2pmobile');
    }
    else{
      _launchURL();
    }
  }

  launchGooglePay() {
    // print("Inside launchGooglePay: " + this.GooglePayInstalled.toString());
    if (this.GooglePayInstalled){
      DeviceApps.openApp('com.google.android.apps.walletnfcrel');
    }
    else{
      _launchGPayURL();
    }
  }

  @override
  Widget build(BuildContext context) {
    getApps();
    return Scaffold(
      drawer: new DrawerCodeOnly(), // provides the nav drawer
      appBar: new AppBar(
        title: new Text("Linked Payments Page"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            _openPayPalButton(),
            SizedBox(
              height: 50.0,
            ),
            _openGooglePayButton(),
          ]
        ),
      ),
    );
  }

  Widget _openPayPalButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: launchPayPal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/pay_pal_logo.png"), height: 35.0), // asset image
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Open PayPal',
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

  Widget _openGooglePayButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: launchGooglePay,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_pay_logo.png"), height: 35.0), // asset image
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Open Google Pay',
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