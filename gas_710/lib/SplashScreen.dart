import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gas_710/NavigationPage.dart';
import 'package:gas_710/OnBoardingPage.dart';
import 'dart:async';

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