import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_710/NavigationPage.dart';
import 'package:gas_710/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  void initState() { 
    super.initState();
    _initSharedPrefs();
  }

  _initSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profileName', "No Name Set");
    prefs.setString('profileEmail', "No Email Set");
    prefs.setString('profileNumber', "No Number Set");
    prefs.setDouble('profileMPG', 0.0);
    prefs.setString('theme', MediaQuery.of(context).platformBrightness == Brightness.dark ? 'Dark' : 'Light');
  }

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
      // pageColor: Colors.white,
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
    return RaisedButton(
      color: (MediaQuery.of(context).platformBrightness == Brightness.dark) ? Colors.grey[700] : Colors.white,
      splashColor: Colors.grey,
      onPressed: () {
        Timer(Duration(seconds: 3), () {});
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
                  color: (MediaQuery.of(context).platformBrightness == Brightness.dark) ? Colors.white : Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}