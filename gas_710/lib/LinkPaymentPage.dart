import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';

class LinkPaymentPage extends StatelessWidget {

  List<Application> apps;

  // Get all installed apps
  getApps() async {
    this.apps = await DeviceApps.getInstalledApplications();
    apps.forEach((element) => print(element.packageName));
    bool isInstalled = await DeviceApps.isAppInstalled('com.paypal.android.p2pmobile');
    print("True?:------ " + isInstalled.toString() + "\n");
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

  @override
  Widget build(BuildContext context) {

    getApps();


    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          onPressed: _launchURL,
          child: new Text('PayPal'),
        ),
      ),
    );
  }
}