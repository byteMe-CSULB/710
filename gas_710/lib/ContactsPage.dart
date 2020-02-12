import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';

class ContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold
    (
      drawer: new DrawerCodeOnly(), // provides the nav drawer
      appBar: new AppBar(
        title: new Text("Contacts Page"),
        backgroundColor: Colors.purple,
      ),
       body: new Container(
        child: new Center(
          child: new Text("This is the contacts page",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),
          )
        )
      )
    );
  }
}