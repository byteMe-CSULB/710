import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold
    (
      drawer: new DrawerCodeOnly(),
      appBar: new AppBar(
        title: new Text("About Page"),
        backgroundColor: Colors.purple,
      ),
      body: new Text("This is the about page"),
    );
  }
}