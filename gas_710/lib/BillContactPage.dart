import 'package:gas_710/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_710/auth.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:gas_710/PdfViewPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

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
        actions: <Widget>[
          StreamBuilder(
            stream: databaseReference.collection('trips').where('passengers', arrayContains: name).snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return IconButton(
                  icon: Icon(Icons.picture_as_pdf),
                  onPressed: () {
                    print('Cannot make PDF');
                  },
                  tooltip: 'Save all of $name\'s trips as a PDF',
                ); 
              }
              return IconButton(
                icon: Icon(Icons.picture_as_pdf),
                onPressed: () async {
                  PermissionStatus permissionStatus = await _getContactPermission();
                  if (permissionStatus == PermissionStatus.granted) {
                    print('Creating PDF');
                    _generatePdf(context, snapshot);
                  }
                },
                tooltip: 'Save all of $name\'s trips as a PDF',
              );
            }
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: 
                    (avatar.toString() != 'none' && (avatar != null && avatar.length > 0))
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
                Column(
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
                      '\$' + money.toString(),
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.green
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
                  if(!snapshot.hasData) return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber));
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
                  if(!snapshot.hasData) return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber));
                  return Expanded(child: _cardListView(context, snapshot));
                }
              ),
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
            ),
          );
        }
    );
  }

  _generatePdf(context, AsyncSnapshot<QuerySnapshot> snapshot) async {
    var snapshotLength = snapshot.data.documents.length;
    List<Trip> trips = [];
    for(int i = 0; i < snapshotLength; i++) {
      DateTime myDateTime = snapshot.data.documents[i]['date'].toDate();
      String dateTime = DateFormat.yMMMMd().format(myDateTime).toString();
      String location = snapshot.data.documents[i]['location'];
      String price = snapshot.data.documents[i]['price'].toString();
      String mile = snapshot.data.documents[i]['miles'].toString();
      Trip individualTrip = Trip(dateTime, location, mile, price);
      trips.add(individualTrip);
    }

    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    List<List<String>> data = [
      <String>['Date', 'Location', 'Miles', 'Price']
    ];
    trips.forEach((element) {
      data.add(element.getTripList());
    });
    pdf.addPage(
      pdfLib.MultiPage(
        build: (context) => [
          pdfLib.Text('Contact Name - $name'),
          pdfLib.Table.fromTextArray(context: context, data: data)
        ]
      )
    );

    final Directory dir = await getExternalStorageDirectory();
    final String path = '${dir.path}/' + DateTime.now().millisecondsSinceEpoch.toString() + '.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    Fluttertoast.showToast(
      msg: 'PDF File Path: $path',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      fontSize: 16.0,
    );
    print('PDF File path: $path');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewPage(path: path),
      ),
    );
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      return permissionStatus[PermissionGroup.storage] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }
}

class Trip {
  String _date;
  String _location;
  String _miles;
  String _price;
  List<String> _trip = [];
  
  Trip(date, location, miles, price) {
    this._date = date;
    this._location = location;
    this._miles = miles;
    this._price = price;
    this._trip = [_date, _location, _miles, _price];
  }

  String getDate() {
    return _date;
  }

  String getLocation() {
    return _location;
  }

  String getMiles() {
    return _miles;
  }

  String getPrice() {
    return _price;
  }

  List<String> getTripList() {
    return _trip;
  }
}
