import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_710/AboutPage.dart';
import 'package:gas_710/BillingPage.dart';
import 'package:gas_710/InfoPage.dart';
import 'package:gas_710/NavigationPage.dart';
import 'package:gas_710/SettingsPage.dart';
import 'package:gas_710/ContactsPage.dart';
import 'package:gas_710/WebViewPage.dart';
import 'package:gas_710/auth.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationPage()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.push(context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 300), () {
    checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlutterLogo( // eventually we should replace this with our actual logo
              size: 100
            ),
            Text('710 by byteMe')
          ]
        ), 
      ),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NavigationPage()));
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Rideshare with friends",
          body: 
            "Instead of picking up random strangers, pick up your friends or family!",
          image: Align(
            child: Image.asset('assets/car.png', width: 350.0),
            alignment: Alignment.bottomCenter
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Search for destinations",
          body:
            "Look any place that you would like to go with your passengers.",
          image: Align(
            child: Image.asset('assets/tour.png', width: 350.0),
            alignment: Alignment.bottomCenter
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Keep all records",
          body:
            "We save everything for you to make it easier to track.",
          image: Align(
            child: Image.asset('assets/folder.png', width: 350.0),
            alignment: Alignment.bottomCenter
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Send a bill",
          body: "If someone owes you anything, send them a little nudge with our receipts.",
          image: Align(
            child: Image.asset('assets/invoice.png', width: 350.0),
            alignment: Alignment.bottomCenter
          ),
          footer: _signInButton(),
          decoration: pageDecoration,
        ),
      ],
      onDone: () {
        if(signedIn) {
          _onIntroEnd(context);
        } else {
          Fluttertoast.showToast(
            msg: 'Please sign in before continuing',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            fontSize: 16.0,
          );
        }
      },
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeColor: Colors.purple,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
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
                return NavigationPage();
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 4,
      highlightedBorderColor: Colors.purple[400],
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
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DrawerCodeOnly extends StatefulWidget {
  @override
  DrawerCodeOnlyState createState() => DrawerCodeOnlyState();
}

class DrawerCodeOnlyState extends State<DrawerCodeOnly> {
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
