import 'package:flutter/material.dart';
import 'package:gas_710/NavigationDrawer.dart';
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
      drawer: NavigationDrawer(), // provides nav drawer
      appBar: new AppBar(
        title: new Text(title),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          NavigationControls(_controller.future),
          IconButton(
            icon: Icon(Icons.open_in_browser, color: Colors.white),
            onPressed: () async {
              if(title == 'Google Pay') {
                if (await DeviceApps.isAppInstalled('com.google.android.apps.walletnfcrel')) {
                  DeviceApps.openApp('com.google.android.apps.walletnfcrel');
                } else {
                  if (await canLaunch(selectedUrl)) {
                    await launch(selectedUrl);
                  } else {
                    throw 'Could not launch $selectedUrl';
                  }
                }
              } else if(title == 'PayPal') {
                if (await DeviceApps.isAppInstalled('com.paypal.android.p2pmobile')) {
                  DeviceApps.openApp('com.paypal.android.p2pmobile');
                } else {
                  if (await canLaunch(selectedUrl)) {
                    await launch(selectedUrl);
                  } else {
                    throw 'Could not launch $selectedUrl';
                  }
                }
              } else if(title == 'Cash App') {
                if (await DeviceApps.isAppInstalled('com.squareup.cash')) {
                  DeviceApps.openApp('com.squareup.cash');
                } else {
                  if (await canLaunch(selectedUrl)) {
                    await launch(selectedUrl);
                  } else {
                    throw 'Could not launch $selectedUrl';
                  }
                }
              } else if(title == 'Venmo') {
                if (await DeviceApps.isAppInstalled('com.venmo')) {
                  DeviceApps.openApp('com.venmo');
                } else {
                  if (await canLaunch(selectedUrl)) {
                    await launch(selectedUrl);
                  } else {
                    throw 'Could not launch $selectedUrl';
                  }
                }
              } else if(title == 'Zelle') {
                if (await DeviceApps.isAppInstalled('com.zellepay.zelle')) {
                  DeviceApps.openApp('com.zellepay.zelle');
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
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      )
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
    : assert(_webViewControllerFuture != null);
  
  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder: 
        (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
          final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
          final WebViewController controller = snapshot.data;
          return Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back
                ),
                color: Colors.white,
                onPressed: !webViewReady 
                ? null 
                : () async {
                  if(await controller.canGoBack()) {
                    controller.goBack();
                  } else {
                    Scaffold.of(context).showSnackBar(
                    const SnackBar(content: Text("No back history item")),);
                    return;
                  }
                }
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: !webViewReady
                  ? null
                  : () async {
                  if (await controller.canGoForward()) {
                    controller.goForward();
                  } else {
                    Scaffold.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("No forward history item")),
                    );
                    return;
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: !webViewReady
                  ? null
                  : () {
                    controller.reload();
                  }
              ),
            ]
          );
        },
    );
  }
}