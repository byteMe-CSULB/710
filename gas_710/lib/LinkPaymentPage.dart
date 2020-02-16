import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';

class LinkPaymentPage extends StatelessWidget {

  _launchURL() async {
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          onPressed: _launchURL,
          child: new Text('Show Flutterr homepage'),
        ),
      ),
    );
  }
}


/*

_openJioSavaan (data) async
{String dt = data['JioSavaan'] as String;
  bool isInstalled = await DeviceApps.isAppInstalled('com.jio.media.jiobeats');
if (isInstalled != false)
 {
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: dt
  );
  await intent.launch();
 }
else
  {
  String url = dt;
  if (await canLaunch(url))
    await launch(url);
   else
    throw 'Could not launch $url';
}
}

 */