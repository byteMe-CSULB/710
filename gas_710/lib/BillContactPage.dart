import 'package:gas_710/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_710/auth.dart';
import 'package:intl/intl.dart';
import 'package:gas_710/createTXT.dart';

class BillContactPage extends StatelessWidget {
  final name, money, avatar; // required keys from BillingPage.dart
  BillContactPage({Key key, @required this.name, @required this.money, @required this.avatar})
      : super(key: key); // eventually we should add more keys

  final databaseReference = Firestore.instance.collection('userData').document(firebaseUser.email);
  bool sortDesc = true;

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
                  child: 
                    (avatar != null && avatar.length > 0)
                      ? 
                    CircleAvatar(
                      backgroundImage: MemoryImage(avatar),
                      radius: 48.0,
                    )
                      : 
                    CircleAvatar(
                      child: Text(
                        name[0],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48.0
                        ),
                      ),
                      radius: 48.0,
                      backgroundColor: Colors.purple
                    ),
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
              StreamBuilder(
                stream: databaseReference.collection('contacts').where('displayName', isEqualTo: name).snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return CircularProgressIndicator();
                  return Container(
                    height: 150,
                    child: Column(
                      children:<Widget> [
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text('Phone Number'),
                          subtitle: Text(snapshot.data.documents[0]['phoneNumber']),
                        ),
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text('Email Address'),
                          subtitle: Text(snapshot.data.documents[0]['emailAddress']),
                        ),
                      ]
                    ),
                  );
                }
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
                  IconButton( // it's a useless button for now
                    icon: Icon(Icons.filter_list),
                    color: Colors.grey,
                    onPressed: () {
                      sortDesc = !sortDesc;
                    },
                  ),
                ]
              ),
              StreamBuilder(
              stream: databaseReference.collection('trips').where('passengers', arrayContains: name).orderBy('date').snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) return CircularProgressIndicator();
                return Expanded(child: _cardListView(context, snapshot));
              }),
            ]
          ),
        )
      );
  }

  Widget _cardListView(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) { // card list view builder widget
    var snapshotLength = snapshot.data.documents.length;
    var trips = [];
    var dates = [];

    for(int i = 0; i < snapshotLength; i++) {
      trips.add(snapshot.data.documents[i]['location']);
      DateTime myDateTime = snapshot.data.documents[i]['date'].toDate();
      dates.add(DateFormat.yMMMMd().format(myDateTime).toString());
    }

    return ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            child: ListTile(
              leading: Text(
                (index + 1).toString(), // for quick ordering, essentially should be in chronological order
              ),
              title: Text(
                trips[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                dates[index]
              ),
              onLongPress: () {
                print('Writing Txt');
                write(name, double.parse(money), trips[index], dates[index]);
              }
            ),
          );
        }
    );
  }
}
