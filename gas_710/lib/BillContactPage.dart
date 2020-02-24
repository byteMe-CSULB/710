import 'package:gas_710/main.dart';
import 'package:flutter/material.dart';
import 'package:gas_710/BillingPage.dart';

class BillContactPage extends StatelessWidget {
  final name, money;
  BillContactPage({Key key, @required this.name, @required this.money}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text(name),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 180.0,
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.topCenter,
              color: Colors.grey[300],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 32.0
                        ),
                      ),
                      Text(
                        money,
                        style: TextStyle(
                          fontSize: 28.0
                        ),
                      )
                    ],
                  ),
                  CircleAvatar(
                    radius: 42.0,
                    backgroundColor: Colors.purple,
                    child: Text(
                      name[0],
                      style: TextStyle(
                        fontSize: 54.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}