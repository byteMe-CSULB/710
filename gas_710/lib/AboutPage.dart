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
            child: new Text("\nThe Idea\n-------------\n"
                "We aim to provide an easy way to split the cost of fuel "
                "with your friends.\n"
                "Search for your destination on the Navigation page, then add "
                "the other passengers to the ride.\n "
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