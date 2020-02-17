import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold
      (
        drawer: new DrawerCodeOnly(), // provides nav drawer
        appBar: new AppBar(
          title: new Text("Firestore Test"),
          backgroundColor: Colors.purple,
        ),

        body: StreamBuilder(
          stream: Firestore.instance.collection('gas').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading.. please wait..');
            return Column(children: <Widget>[
              Text(snapshot.data.documents[0]['price'].toString(),
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),
              )
            ],
            );
          },

        )

    );


  }
}
