import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';

class LinkPaymentPage extends StatelessWidget {

  List<Application> apps;
  bool PayPalInstalled;

  // Get all installed apps
  getApps() async {
    this.apps = await DeviceApps.getInstalledApplications();
    apps.forEach((element) => print(element.packageName));
    this.PayPalInstalled = await DeviceApps.isAppInstalled('com.paypal.android.p2pmobile');
    print("True?:------ " + PayPalInstalled.toString() + "\n");
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

  launchPayPal()
  {
    print("Inside launchPayPal: " + this.PayPalInstalled.toString());
    if (this.PayPalInstalled)
      {
        DeviceApps.openApp('com.paypal.android.p2pmobile');
      }
    else
      {
        _launchURL();
      }
  }

  @override
  Widget build(BuildContext context) {

    getApps();


    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          onPressed: launchPayPal,
          child: new Text('PayPal'),
        ),
      ),
    );
  }
}