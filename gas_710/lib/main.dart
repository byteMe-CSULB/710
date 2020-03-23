import 'package:flutter/material.dart';
import 'package:gas_710/AboutPage.dart';
import 'package:gas_710/BillingPage.dart';
import 'package:gas_710/InfoPage.dart';
import 'package:gas_710/NavigationPage.dart';
import 'package:gas_710/SettingsPage.dart';
import 'package:gas_710/LinkPaymentPage.dart';
import 'package:gas_710/ContactsPage.dart';
import 'package:gas_710/auth.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: NavigationPage(),
    );
  }
}

class GasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: DrawerCodeOnly(),
        appBar: AppBar(
          title: Text('7 ! 0'),
          backgroundColor: Colors.purple,
        ),
        body: new Container(
            child: new Center(
                child: new Text(
          "This is the main page",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),
        ))));
  }
}

class DrawerCodeOnly extends StatelessWidget {
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
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new LinkPaymentPage()));
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
                // SnackBar at the bottom, displays that the feature is planned, but not implemented yet
                /*
                  Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Feature not implemented yet"),
                )); */
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

  /*
     Setups email for user to send bug report.
     User still has to hit send button.
  */
  void sendBugReport() async {

    // Get current date & time
    DateTime now = DateTime.now();

    String minutes;

    if(now.minute < 10)
      now.minute.toString().padLeft(1, '0');
    else
      minutes = now.minute.toString();

    // Setup bug report email
    final Email bugReport = Email(

      // Email for developers to read bug reporst
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
