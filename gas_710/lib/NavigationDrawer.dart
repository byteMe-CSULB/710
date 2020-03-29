import 'package:flutter/material.dart';
import 'package:gas_710/AboutPage.dart';
import 'package:gas_710/BillingPage.dart';
import 'package:gas_710/InfoPage.dart';
import 'package:gas_710/NavigationPage.dart';
import 'package:gas_710/SettingsPage.dart';
import 'package:gas_710/ContactsPage.dart';
import 'package:gas_710/WebViewPage.dart';
import 'package:gas_710/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  NavigationDrawerState createState() => NavigationDrawerState();
}

class NavigationDrawerState extends State<NavigationDrawer> {
  bool _signedIn = false;
  Future checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      return _signedIn = prefs.getBool('signedIn');
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
                        style: TextStyle(fontSize: 17)),
                  ),
                  decoration: BoxDecoration(color: Colors.amber),
                ),
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
                      builder: (context) => new ContactsPage()));
            },
          ),
          new ListTile(
              leading: Icon(Icons.compare_arrows),
              title: Text("Link to payment services"),
              onTap: () {
                Navigator.pop(context);
                if(prefService == PaymentServices.gpay) {
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WebViewPage(
                    title: "Google Pay",
                    selectedUrl: "https://pay.google.com",
                  )));
                } else if(prefService == PaymentServices.paypal) {
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WebViewPage(
                    title: "PayPal",
                    selectedUrl: "https://www.paypal.com/us/home",
                  )));
                } else if(prefService == PaymentServices.cashapp) {
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WebViewPage(
                    title: "CashApp",
                    selectedUrl: "https://cash.app/",
                  )));
                } else if(prefService == PaymentServices.venmo) {
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WebViewPage(
                    title: "Venmo",
                    selectedUrl: "https://venmo.com/",
                  )));
                } else if(prefService == PaymentServices.zelle) {
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
                // SnackBar at the bottom, displays that the feature is planned, but not implemented yet
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Feature not implemented yet"),
                ));
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
              }),
        ],
      ),
    );
  }
}