import 'package:flutter/material.dart';
import 'package:gas_710/main.dart';
import 'package:gas_710/NavigationPage.dart';

class TripSummaryPage extends StatelessWidget {
  final selected, miles, location;
  TripSummaryPage({Key key, @required this.selected, @required this.location, @required this.miles}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text("Trip Summary Page"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.directions,
                  size: 60.0
                ),
                title: Text(
                  'Your Trip',
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                subtitle: Text(
                  '$miles miles to $location',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                child: ListView.separated(
                  separatorBuilder: (context, index) => 
                    SizedBox(
                      width: 5.0,
                    ),
                  scrollDirection: Axis.horizontal,
                  itemCount: selected.length,
                  itemBuilder: (BuildContext context, int index) =>
                    Chip(
                      label: Text(
                        selected[index],
                        style: TextStyle(color: Colors.black)
                      ),
                    ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => new NavigationPage()));
                    },
                    child: Text(
                      'Cancel'
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      // open GoogleMaps
                    },
                    child: Text(
                      'Open GoogleMaps'
                    ),
                    color: Colors.amber
                  ),
                ],
              ),
            ],
          )
        )
      )
    );
  }
}