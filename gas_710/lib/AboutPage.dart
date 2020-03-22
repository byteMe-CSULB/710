import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold
    (
      drawer: new DrawerCodeOnly(), // provides the nav drawer
      appBar: new AppBar(
        title: new Text("About Page"),
        backgroundColor: Colors.purple,
      ),
       body: new Container(
          margin: new EdgeInsets.symmetric(horizontal: 20.0),
          child: new Align(alignment: Alignment.topLeft,
            child: new Text("The Idea\n-------------\n"
                "\nbyteMe\n-------------\n"
                "Brandon Nhem\n"
                "Christopher Tran\n"
                "Meng Cha\n"
                "Taylor Meyer\n\n"
                "CSULB Spring 2020",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),
          )
        )
      )
    );
  }
}