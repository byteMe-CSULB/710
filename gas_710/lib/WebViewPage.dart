import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatelessWidget {
  final String title;
  final String selectedUrl;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
      
  WebViewPage({
    @required this.title,
    @required this.selectedUrl,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text(title),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.open_in_browser, color: Colors.white),
            onPressed: () async {
              if(selectedUrl.contains('google')) {
                if (await DeviceApps.isAppInstalled('com.google.android.apps.walletnfcrel')) {
                  DeviceApps.openApp('com.google.android.apps.walletnfcrel');
                } else {
                  if (await canLaunch(selectedUrl)) {
                    await launch(selectedUrl);
                  } else {
                    throw 'Could not launch $selectedUrl';
                  }
                }
              } else if(selectedUrl.contains('paypal')) {
                if (await DeviceApps.isAppInstalled('com.paypal.android.p2pmobile')) {
                  DeviceApps.openApp('com.paypal.android.p2pmobile');
                } else {
                  if (await canLaunch(selectedUrl)) {
                    await launch(selectedUrl);
                  } else {
                    throw 'Could not launch $selectedUrl';
                  }
                }
              }
            }
          ),
        ],
      ),
      body: WebView(
        initialUrl: selectedUrl,
        javascriptMode: JavascriptMode.disabled,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      )
    );
  }
}