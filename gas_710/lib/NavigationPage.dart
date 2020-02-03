import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold
    (
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text("Navigation Page"),
        backgroundColor: Colors.purple,

      ),
      body: new Container(
        child: new Center(
          child: new Text("This is the navigation page",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),
          )
        )
      )
    );
  }
}