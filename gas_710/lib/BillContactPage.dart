import 'package:gas_710/main.dart';
import 'package:flutter/material.dart';

class BillContactPage extends StatelessWidget {
  final name, money; // required keys from BillingPage.dart
  BillContactPage({Key key, @required this.name, @required this.money})
      : super(key: key); // eventually we should add more keys

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new DrawerCodeOnly(), // provides nav drawer
      appBar: new AppBar(
        title: new Text(name),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar( //ToDo: add contact image, for now, first letter of name
                    backgroundColor: Colors.purple,
                    child: Text(
                      name[0],
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                      ),
                    ),
                    radius: 48),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    ' - \$' + money.toString(),
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                ),
              ]
            ),
            SizedBox(
              height: 10
            ),
            Divider(
              thickness: 0.8,
            ),
            Align(
              alignment: Alignment.centerLeft,
                          child: Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              height: 150,
              child: Column(
                children:<Widget> [
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Phone Number'),
                    subtitle: Text('(123) 456-7890'),
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text('Email Address'),
                    subtitle: Text('${name.toLowerCase().replaceAll(new RegExp(r"\s+\b|\b\s"), "")}@email.com'), // the fancy regex will be removed later on
                  ),
                ]
              ),
            ),
            Divider(
              thickness: 0.8,
            ),
            Row(
              children:<Widget> [
                Text(
                  'Recent Trips',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                Spacer(),
                Icon( // this does nothing rn
                  Icons.filter_list,
                  color: Colors.grey,
                ),
              ]
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(child: _cardListView(context)),
          ]
        ),
      ),
    );
  }

  Widget _cardListView(BuildContext context) { // card list view builder widget
    // dates on when the user last went on a trip with this person
    var dates = [
    'Mar 1, 2019',
    'Apr 20, 2019',
    'May 4, 2019',
    'Aug 25, 2019',
    ];

    // the locations that the user went with
    var places = [
      'CSULB',
      'Taco Bell',
      'San Diego',
      'Home',
    ];

    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          child: ListTile(
            leading: Text(
              (index + 1).toString(), // for quick ordering, essentially should be in chronological order
            ),
            title: Text(
              places[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              dates[index]
            ),
          ),
        );
      }
    );
  }
}
