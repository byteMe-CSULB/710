import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gas_710/main.dart';
import 'package:gas_710/auth.dart';
import 'package:gas_710/AccountPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PaymentServices {paypal, gpay, cashapp, venmo, zelle}
PaymentServices prefService = PaymentServices.paypal;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {  
  String _name, _email, _number;

  Future editProfile(String editName, editEmail, editNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profileName', editName);
    prefs.setString('profileEmail', editEmail);
    prefs.setString('profileNumber', editNumber);

    setState(() {
      _name = prefs.getString('profileName');
      _email = prefs.getString('profileEmail');
      _number = prefs.getString('profileNumber');
    });
  }

  Future getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString('profileName') ?? "No Name Set");
      _email = (prefs.getString('profileEmail') ?? "No Email Set");
      _number = (prefs.getString('profileNumber') ?? "No Number Set");
    });
  }

  @override
  void initState() { 
    super.initState();
    getProfile();
  }

  final textControllerName = TextEditingController();
  final textControllerEmail = TextEditingController();
  final textControllerNumber = TextEditingController();


  @override
  void dispose() {
    textControllerName.dispose();
    textControllerEmail.dispose();
    textControllerNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text("Settings Page"),
        backgroundColor: Colors.purple,
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preferred Payment Services',
                style: TextStyle(
                  fontSize: 24
                )
              ),
            ),
          ),
          ListTile(
            title: const Text('PayPal'),
            leading: Radio(
              value: PaymentServices.paypal,
              groupValue: prefService,
              onChanged: (PaymentServices value) {
                setState(() {
                  prefService = value;
                });
              }
            )
          ),
          ListTile(
            title: const Text('Google Pay'),
            leading: Radio(
              value: PaymentServices.gpay,
              groupValue: prefService,
              onChanged: (PaymentServices value) {
                setState(() {
                  prefService = value;
                });
              }
            )
          ),
          ListTile(
            title: const Text('Cash App'),
            leading: Radio(
              value: PaymentServices.cashapp,
              groupValue: prefService,
              onChanged: (PaymentServices value) {
                setState(() {
                  prefService = value;
                });
              }
            )
          ),
          ListTile(
            title: const Text('Venmo'),
            leading: Radio(
              value: PaymentServices.venmo,
              groupValue: prefService,
              onChanged: (PaymentServices value) {
                setState(() {
                  prefService = value;
                });
              }
            )
          ),
          ListTile(
            title: const Text('Zelle'),
            leading: Radio(
              value: PaymentServices.zelle,
              groupValue: prefService,
              onChanged: (PaymentServices value) {
                setState(() {
                  prefService = value;
                });
              }
            )
          ),
          Divider(),
          SizedBox(
            width: double.infinity,
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sign in Here!',
                style: TextStyle(
                  fontSize: 24
                )
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 10.0,
          ),
          _signInButton(), // log in with Google Button
          SizedBox(
            width: double.infinity,
            height: 10.0,
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[ 
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Contact Profile',
                    style: TextStyle(
                      fontSize: 24
                    )
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog();
                  },
                  tooltip: 'Edit Profile',
                ),
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Name - $_name',
                    style: TextStyle(
                      fontSize: 18.0
                    )
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email - $_email',
                    style: TextStyle(
                      fontSize: 18.0
                    )
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Name - $_number',
                    style: TextStyle(
                      fontSize: 18.0
                    )  
                  ),
                )
              ],
            )
          )
        ],
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
                return AccountPage();
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
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
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showEditDialog() {
    String editName, editEmail, editNumber;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: 24.0,
                    ))
                ),
                TextFormField(
                  controller: textControllerName,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    border: InputBorder.none,
                    hintText: 'Enter full name'
                  ),
                ),
                TextFormField(
                  controller: textControllerEmail,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    border: InputBorder.none,
                    hintText: 'Enter email'
                  ),
                ),
                TextFormField(
                  controller: textControllerNumber,
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    border: InputBorder.none,
                    hintText: 'Enter number'
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        textControllerName.clear();
                        textControllerEmail.clear();
                        textControllerNumber.clear();
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      child: Text('Confirm'),
                      color: Colors.amber,
                      onPressed: () {
                        editName = textControllerName.text;
                        editEmail = textControllerEmail.text;
                        editNumber = textControllerNumber.text;
                        print('Saving Profile - $editName $editEmail $editNumber');
                        editProfile(editName, editEmail, editNumber);
                        textControllerName.clear();
                        textControllerEmail.clear();
                        textControllerNumber.clear();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            )
          )
        );
      }
    );
  }
}