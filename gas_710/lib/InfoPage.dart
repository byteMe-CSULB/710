import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold
    (
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text("Info Page"),
        backgroundColor: Colors.purple,
      ),
      body: new Text("This is the info page"),
    );
  }
}