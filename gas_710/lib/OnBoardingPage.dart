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

  final textControllerName = TextEditingController();
  final textControllerEmail = TextEditingController();
  final textControllerNumber = TextEditingController();
  final textControllerMPG = TextEditingController();

  @override
  void dispose() {
    textControllerName.dispose();
    textControllerEmail.dispose();
    textControllerNumber.dispose();
    textControllerMPG.dispose();
    super.dispose();
  }

  _initSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profileName', "No Name Set");
    prefs.setString('profileEmail', "No Email Set");
    prefs.setString('profileNumber', "No Number Set");
    prefs.setDouble('profileMPG', 0.0);
    await prefs.setString('theme', MediaQuery.of(context).platformBrightness == Brightness.dark ? 'Dark' : 'Light');
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
      imagePadding: EdgeInsets.zero,
    );
    const profilePageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      titlePadding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
      bodyTextStyle: bodyStyle,
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
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Create your profile",
          bodyWidget: _createProfile(),
          footer: _signInButton(),
          decoration: profilePageDecoration
        )
      ],
      onDone: () {
        if(signedIn && profileCreated) {
          _onIntroEnd(context);
        } else if(signedIn && !profileCreated) {
          Fluttertoast.showToast(
            msg: 'Please create your profile before continuing',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            fontSize: 16.0,
          );
        } else if(!signedIn && profileCreated) {
          Fluttertoast.showToast(
            msg: 'Please sign in before continuing',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            fontSize: 16.0,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Please sign in and create your profile before continuing',
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

  Future editProfile(String editName, String editEmail, String editNumber, double editMPG) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profileName', editName);
    prefs.setString('profileEmail', editEmail);
    prefs.setString('profileNumber', editNumber);
    prefs.setDouble('profileMPG', editMPG);
  }
  
  bool profileCreated = false;
  final _profileKey = GlobalKey<FormState>();
  Widget _createProfile() {
    String editName, editEmail, editNumber;
    double editMPG;
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 450.0,
          child: Form(
            key: _profileKey,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ 
                    Text(
                      "Enter Profile Information",
                      style: TextStyle(
                        fontSize: 24.0,
                      )
                    ),
                    SizedBox(
                      width: 10.0
                    ),
                    Icon(
                      Icons.check,
                      color: profileCreated ? Colors.green : Colors.grey,
                      size: 36.0
                    )
                  ]
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: textControllerName,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      border: InputBorder.none,
                      hintText: 'Enter full name'
                    ),
                    validator: (String value) {
                      return value.isEmpty ? 'Field cannot be empty' : null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: textControllerEmail,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      border: InputBorder.none,
                      hintText: 'Enter email',
                    ),
                    validator: (String value) {
                      return value.isEmpty ? 'Field cannot be empty' : null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: textControllerNumber,
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      border: InputBorder.none,
                      hintText: 'Enter phone number'
                    ),
                    validator: (String value) {
                      return value.isEmpty ? 'Field cannot be empty' : null;
                    },
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                  child: TextFormField(
                    controller: textControllerMPG,
                    decoration: InputDecoration(
                      icon: Icon(Icons.directions_car),
                      border: InputBorder.none,
                      hintText: 'Enter MPG'
                    ),
                    validator: (String value) {
                      return value.isEmpty ? 'Field cannot be empty' : null;
                    },
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                ),
                Spacer(), // there's a lot of space in between the forms and button 
                          // bc I needed to make room for validation error
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Clear'),
                      onPressed: () {
                        textControllerName.clear();
                        textControllerEmail.clear();
                        textControllerNumber.clear();
                        textControllerMPG.clear();
                      },
                    ),
                    RaisedButton(
                      child: Text('Confirm'),
                      color: Colors.amber,
                      onPressed: () {
                        if(_profileKey.currentState.validate()) {
                          editName = textControllerName.text;
                          editEmail = textControllerEmail.text;
                          editNumber = textControllerNumber.text;
                          editMPG = double.parse(textControllerMPG.text);
                          print('Saving Profile - $editName $editEmail $editNumber $editMPG');
                          editProfile(editName, editEmail, editNumber, editMPG);
                          textControllerName.clear();
                          textControllerEmail.clear();
                          textControllerNumber.clear();
                          textControllerMPG.clear();
                          Fluttertoast.showToast(
                            msg: 'Profile saved!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            fontSize: 16.0,
                          );
                          setState(() {
                            profileCreated = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      )
    );
  }

  bool signedInComplete = false;
  Widget _signInButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:<Widget>[
        RaisedButton(
          color: (MediaQuery.of(context).platformBrightness == Brightness.dark) ? Colors.grey[700] : Colors.white,
          splashColor: Colors.grey,
          onPressed: () {
            signInWithGoogle().whenComplete((){
              setState(() {
                signedInComplete = true;
              });
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
        ),
        SizedBox(
          width: 10.0
        ),
        Icon(
          Icons.check,
          color: signedInComplete ? Colors.green : Colors.grey,
          size: 36.0
        )
      ]
    );
  }
}