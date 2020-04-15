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
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'dart:collection';

class BillContactPage extends StatefulWidget {
  final name, money, avatar; // required keys from BillingPage.dart
  const BillContactPage(
      {Key key,
      @required this.name,
      @required this.money,
      @required this.avatar})
      : super(key: key); // eventually we should add more keys

  @override
  _BillContactPageState createState() => _BillContactPageState();
}

class _BillContactPageState extends State<BillContactPage> {
  final databaseReference =
      Firestore.instance.collection('userData').document(firebaseUser.email);
  bool sortDesc = true;

  Permission _storagePermission = Permission.storage;
  PermissionStatus _storagePermissionStatus = PermissionStatus.undetermined;

  @override
  initState() {
    super.initState();
    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await _storagePermission.status;
    setState(() => _storagePermissionStatus = status);
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    setState((){
      print(status);
      _storagePermissionStatus = status;
      print(_storagePermissionStatus);
    });
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.name),
          backgroundColor: Colors.purple,
          actions: <Widget>[
            StreamBuilder(
                stream: databaseReference
                    .collection('trips')
                    .where('passengers', arrayContains: widget.name)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return IconButton(
                      icon: Icon(Icons.picture_as_pdf),
                      onPressed: () {
                        print('Cannot make PDF');
                      },
                      tooltip: 'Save all of ${widget.name}\'s trips as a PDF',
                    );
                  }
                  return IconButton(
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: () async {
                      if (_storagePermissionStatus == PermissionStatus.granted) {
                        print('Creating PDF');
                        _generatePdf(context, snapshot);
                      } else {
                        requestPermission(_storagePermission).then((PermissionStatus status){
                          if(status == PermissionStatus.granted) {
                            print('Creating PDF');
                            _generatePdf(context, snapshot);
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Storage permission required to create PDF',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              fontSize: 16.0,
                            );
                          }
                        });
                      }
                    },
                    tooltip: 'Save all of ${widget.name}\'s trips as a PDF',
                  );
                })
          ],
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, 
        children: <Widget>[
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: (widget.avatar.toString() != 'none' && (widget.avatar != null && widget.avatar.length > 0))
                  ? MemoryImage(
                      widget.avatar
                    )
                  : AssetImage('assets/noAvatar.jpg'),
                  fit: BoxFit.fill,
              )
            ),
          ),
          ListTile(
            title: Text(
              widget.name,
              style: TextStyle(
                fontSize: 36.0,
              ),
            ),
            subtitle: Text(
              (widget.money.toString().contains('-'))
                ? '-\$${(widget.money * -1).toString()}'
                : '\$${widget.money.toString()}',
              style: TextStyle(
                fontSize: 36.0,
                color: (widget.money > 0) ? Colors.green : Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: databaseReference
                  .collection('contacts')
                  .where('displayName', isEqualTo: widget.name)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.amber));
                return Container(
                  height: 150,
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: Column(children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone Number'),
                      subtitle:
                          Text(snapshot.data.documents[0]['phoneNumber']),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Email Address'),
                      subtitle:
                          Text(snapshot.data.documents[0]['emailAddress']),
                    ),
                  ]),
                );
              }),
          Divider(
            thickness: 0.8,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: Row(children: <Widget>[
              Text(
                'Recent Trips',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              Text('Sorting by: ', style: TextStyle(color: Colors.grey)),
              Text(sortDesc ? 'Most Recent' : 'Least Recent',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[600])),
              IconButton(
                icon: Icon(Icons.filter_list),
                color: Colors.grey,
                onPressed: () {
                  setState(() {
                    sortDesc = !sortDesc;
                  });
                },
                tooltip: 'Sort by date',
              ),
            ]),
          ),
          StreamBuilder(
              stream: sortDesc
                  ? databaseReference
                      .collection('trips')
                      .where('passengers', arrayContains: widget.name)
                      .orderBy('date', descending: true)
                      .snapshots()
                  : databaseReference
                      .collection('trips')
                      .where('passengers', arrayContains: widget.name)
                      .orderBy('date')
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.amber));
                return Expanded(child: _cardListView(context, snapshot));
              }),
        ]));
  }

  Widget _cardListView(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    // card list view builder widget
    var snapshotLength = snapshot.data.documents.length;
    var trips = []; //location names
    var dates = [];
    List<String> tripId = []; //list of trip id from Firebase.
    List<bool> paidTrips = []; //List of paid Trips
    for (int i = 0; i < snapshotLength; i++) {
      trips.add(snapshot.data.documents[i]['location']);
      tripId.add(snapshot.data.documents[i].documentID); //Get trips id
      //Get passengersPaid data from Firebase
      HashMap tempPaidTrips = new HashMap<String, dynamic>.from(
          snapshot.data.documents[i]['passengersPaid']);
      paidTrips.add(tempPaidTrips[widget.name]);
      DateTime myDateTime = snapshot.data.documents[i]['date'].toDate();
      dates.add(DateFormat.yMMMMd().format(myDateTime).toString());
    }

    return ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return ExpansionTileCard(
            leading: Text( // TODO: find a place for the PAID tag
              (paidTrips[index])
                  ? (index + 1).toString() + '\n Paid'
                  : (index + 1)
                      .toString(), // for quick ordering, essentially should be in chronological order
            ),
            title: Text(
              trips[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(dates[index]),
            children: <Widget>[
              Divider(
                thickness: 1.0,
                height: 1.0,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                        'Miles - ${snapshot.data.documents[index]['miles']}',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                        'Passengers on This Trip (\$${snapshot.data.documents[index]['price']})',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                  )),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 2.0,
                    ),
                    child: Text(
                        snapshot.data.documents[index]['passengers']
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', ''),
                        style: TextStyle(
                          fontSize: 16.0,
                        ))),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                        snapshot.data.documents[index]['driverPhone'] ==
                                "NO PHONE NUMBER PROVIDED"
                            ? 'Driver - ${snapshot.data.documents[index]['driverName']} (${snapshot.data.documents[index]['driverEmail']})'
                            : 'Driver - ${snapshot.data.documents[index]['driverName']} [${snapshot.data.documents[index]['driverPhone']}]',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                  )),
              ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                buttonHeight: 52.0,
                buttonMinWidth: 70.0,
                children: <Widget>[
                  FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      onPressed: () {
                        HashMap passengersPaidList =
                            new HashMap<String, dynamic>.from(snapshot
                                .data.documents[index]['passengersPaid']);
                        if (!passengersPaidList[widget.name]) {
                          passengersPaidList.update(widget.name, (v) => true);
                          databaseReference
                              .collection('trips')
                              .document(tripId[index])
                              .updateData(
                                  {'passengersPaid': passengersPaidList});
                        }
                      },
                      // this should keep the bill in firebase
                      // but just say it's paid and still show it to users
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.check),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0)),
                          Text('Paid')
                        ],
                      )),
                  FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      onPressed:
                          () {}, // this should edit the individual trip i.e change location, miles, passengers, etc.
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.create),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0)),
                          Text('Edit')
                        ],
                      )),
                  FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      onPressed:
                          () {}, // this should share this individual trip with the contact
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.share),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0)),
                          Text('Share')
                        ],
                      )),
                  //Delete Button
                  FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildDeleteDialog(context, tripId, index),
                        );
                      }, // this deletes only the current passenger from the trip
                      //update Firebase to add "(Delete)" at the end of the passenger's name
                      //This allows the other passengers to still see the trip and have the trip still saved in Firebase.
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.delete),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0)),
                          Text('Delete')
                        ],
                      ))
                ],
              ),
            ],
          );
        });
  }

  _generatePdf(context, AsyncSnapshot<QuerySnapshot> snapshot) async {
    var snapshotLength = snapshot.data.documents.length;
    List<Trip> trips = [];
    for (int i = 0; i < snapshotLength; i++) {
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
    pdf.addPage(pdfLib.MultiPage(
        build: (context) => [
              pdfLib.Text('Contact Name - ${widget.name}'),
              pdfLib.Table.fromTextArray(context: context, data: data)
            ]));

    final Directory dir = await getExternalStorageDirectory();
    final String path = '${dir.path}/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.pdf';
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

  // Alert Dialog when deleting Trip
  Widget _buildDeleteDialog(
      BuildContext context, List<String> tripId, int index) {
    return new AlertDialog(
      title: new Text("Delete This Trip"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
              "Pressing \'Delete For All\' will delete the whole trip for everyone. \n"),
          new Text(
              "Pressing \'Only Me\' will delete the trip just for this passenger. Other passengers can still see this trip. \n"),
        ],
      ),
      actions: <Widget>[
        //Button to Cancel
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white
            )
          ),
        ),
        // Button for 'Only Me'
        new RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
            databaseReference
                .collection('trips')
                .document(tripId[index])
                .updateData({
              'passengers': FieldValue.arrayRemove([widget.name])
            });
            databaseReference
                .collection('trips')
                .document(tripId[index])
                .updateData({
              'passengers': FieldValue.arrayUnion([widget.name + "(Deleted)"])
            });
          },
          color: Colors.amber,
          child: const Text('Only Me'),
        ),
        //Button to Delete For All
        new RaisedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => new AlertDialog(
                  title: new Text("Are you sure you want to delete this trip?"),
                  content: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text("This cannot be undone.\n"),
                      ]),
                  actions: <Widget>[
                    //Button to Cancel
                    new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white
                        )
                      ),
                    ),
                    new RaisedButton(
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
                        databaseReference
                            .collection('trips')
                            .document(tripId[index])
                            .delete();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete'),
                    ),
                  ]),
            );
          },
          color: Colors.red,
          child: const Text('Delete For All'),
        ),
      ],
    );
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
