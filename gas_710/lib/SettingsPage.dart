import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';


class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold
    (
      drawer: new DrawerCodeOnly(),
      appBar: new AppBar(
        title: new Text("Settings Page"),
        backgroundColor: Colors.purple,
      ),
      body: Builder(
        builder: (context) => Center(
          child: RaisedButton(
            child: Text("Sign In"),
            onPressed: () => _showToast(context),
            color: Colors.purple[300],
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            splashColor: Colors.purple[900],
          ),
        ),)
    );
  }
}

void _showToast(BuildContext context) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(content: const Text('Signing in..'),
    action: SnackBarAction(label: 'LOGOUT', onPressed: scaffold.hideCurrentSnackBar))
  );
}