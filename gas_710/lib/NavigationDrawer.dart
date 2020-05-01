import 'package:flutter/material.dart';
import 'package:gas_710/AboutPage.dart';
import 'package:gas_710/BillingPage.dart';
import 'package:gas_710/InfoPage.dart';
import 'package:gas_710/NavigationPage.dart';
import 'package:gas_710/SettingsPage.dart';
import 'package:gas_710/contactPages/ContactListPage.dart';
import 'package:gas_710/WebViewPage.dart';
import 'package:gas_710/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gas_710/OnBoardingPage.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart'; 

class NavigationDrawer extends StatefulWidget {
  @override
  NavigationDrawerState createState() => NavigationDrawerState();
}

class NavigationDrawerState extends State<NavigationDrawer> {
  bool _signedIn;
  String _gName, _gEmail, _gImage;

  Future checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _signedIn = (prefs.getBool('signedIn') ?? false);
      _gName = (prefs.getString('gName') ?? 'No name provided check settings');
      _gEmail =
          (prefs.getString('gEmail') ?? 'No email provided check settings');
      _gImage = (prefs.getString('gEmail') ?? 'no image');
    });
  }

  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          signedIn
              ? new UserAccountsDrawerHeader(
                  // IF signed in, nav header is filled with Login Details from auth.dart
                  accountName: new Text(
                    name,
                    style: TextStyle(color: Colors.black),
                  ),
                  accountEmail: new Text(
                    email,
                    style: TextStyle(color: Colors.black),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                      imageUrl,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors
                          .amber), // IF not signed in, message displayed to sign in through settings page
                )
              : new DrawerHeader(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                        "Please sign in, check Settings!", // message to sign in
                        style: TextStyle(fontSize: 17, color: Colors.black)),
                  ),
                  decoration: BoxDecoration(color: Colors.amber),
                ),
          // TODO: fix bug
          // UserAccountsDrawerHeader(
          //   accountName: Text(_gName ?? 'No name provided check settings', style: TextStyle(color: Colors.black)),
          //   accountEmail: Text(_gEmail ?? 'No email provided check settings', style: TextStyle(color: Colors.black)),
          //   currentAccountPicture: (_gImage != 'no image')
          //   ? CircleAvatar(backgroundImage: NetworkImage(imageUrl),)
          //   : CircleAvatar(child: Text(':(', style: TextStyle(fontSize: 24))),
          //   decoration: BoxDecoration(color: Colors.amber),
          // ),
          // Buttons in nav drawer
          new ListTile(
            leading: Icon(Icons.navigation),
            title: Text("Start trip"),
            onTap: () {
              Navigator.pop(
                  context); // Navigator.pop(context) will close the navigation drawer
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NavigationPage())); // Navigator.push(context) will send you the page you choose
            },
          ),
          new ListTile(
            leading: Icon(Icons.attach_money),
            title: Text("Billing"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new BillingPage()));
            },
          ),
          new ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SettingsPage()));
              }),
          new ListTile(
              leading: Icon(Icons.info),
              title: Text("Info"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new InfoPage()));
              }),
          new ListTile(
              leading: Icon(Icons.people),
              title: Text("About"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new AboutPage()));
              }),
          Divider(color: Colors.grey[400]),
          new ListTile(
            leading: Icon(Icons.contacts),
            title: Text("Open contacts"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new ContactListPage()));
            },
          ),
          new ListTile(
              leading: Icon(Icons.compare_arrows),
              title: Text("Link to payment services"),
              onTap: () {
                Navigator.pop(context);
                if (prefService == PaymentServices.gpay) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => WebViewPage(
                            title: "Google Pay",
                            selectedUrl: "https://pay.google.com",
                          )));
                } else if (prefService == PaymentServices.paypal) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => WebViewPage(
                            title: "PayPal",
                            selectedUrl: "https://www.paypal.com/us/home",
                          )));
                } else if (prefService == PaymentServices.cashapp) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => WebViewPage(
                            title: "CashApp",
                            selectedUrl: "https://cash.app/",
                          )));
                } else if (prefService == PaymentServices.venmo) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => WebViewPage(
                            title: "Venmo",
                            selectedUrl: "https://venmo.com/",
                          )));
                } else if (prefService == PaymentServices.zelle) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => WebViewPage(
                            title: "Zelle",
                            selectedUrl: "https://www.zellepay.com/",
                          )));
                }
              }),
          Divider(
            color: Colors.grey[400],
          ),
          new ListTile(
              leading: Icon(Icons.bug_report),
              title: Text("Report an issue"),
              onTap: () {
                Navigator.pop(context);
                sendBugReport();
              }),
          Divider(
            color: Colors.grey[400],
          ),
          new ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Log Out"),
              onTap: () {
                Navigator.pop(context);
                // IF signed in, display SnackBar that user has signed out
                // ELSE, display SnackBar that user is not signed in to be able to sign out
                signedIn
                    ? Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text("Signed out")))
                    : Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text("Not signed in")));
                signOutGoogle(); // call signout method from auth.dart
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OnBoardingPage()));
              }),
        ],
      ),
    );
  }

  sendBugReport() async {
    // Get current date & time
    DateTime now = DateTime.now();
    String minutes;

    if(now.minute < 10)
      now.minute.toString().padLeft(1, '0');
    else
      minutes = now.minute.toString();

    // Setup bug report email
    final Email bugReport = Email(

      // Email for developers to read bug report
      recipients: ['710.bugreport@gmail.com'],

      // Subject contains date & time bug was sent
      // * TODO: Maybe setup Firebase to increment bug report numbers
      subject: 'Bug Report ' + now.hour.toString() + ':' + minutes +
          ', ' + now.month.toString() + '/' + now.day.toString() + '/' + now.year.toString(),

      // Body
      body: 'Describe your issue below, including what you were trying to do at the time:\n\n',

      isHTML: false,
    );
    await FlutterEmailSender.send(bugReport);
  }
}
