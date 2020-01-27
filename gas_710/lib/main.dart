import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gas_710/AboutPage.dart';
import 'package:gas_710/BillingPage.dart';
import 'package:gas_710/InfoPage.dart';
import 'package:gas_710/NavigationPage.dart';
import 'package:gas_710/SettingsPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: GasApp(),
    );
  }
}

class GasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold
    (
      drawer: DrawerCodeOnly(),
      appBar: AppBar(
          title: Text('7 ! 0'),
          backgroundColor: Colors.purple,
      ),
    );
  }
}

class DrawerCodeOnly extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return new Drawer
    (
      child: new ListView
        (
          children: <Widget>
          [
            new UserAccountsDrawerHeader(
                accountName: new Text("User Name"),
                accountEmail: new Text("username@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text('UN'),
                ),
              ),
              new ListTile(
                leading: Icon(Icons.navigation),
                title: Text("Start trip"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new NavigationPage()));
                },
              ),
              new ListTile(
                leading: Icon(Icons.attach_money),
                title: Text("Billing"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new BillingPage()));
                },
              ),
              new ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new SettingsPage()));
                }
              ),
              new ListTile(
                leading: Icon(Icons.info),
                title: Text("Info"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new InfoPage()));
                }
              ),
              new ListTile(
                leading: Icon(Icons.people),
                title: Text("About"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new AboutPage()));
                }
              ),
              Divider(
                color: Colors.grey[400]
                ),
              new ListTile(
                leading: Icon(Icons.contacts),
                title: Text("Open contacts"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              new ListTile(
                leading: Icon(Icons.compare_arrows),
                title: Text("Link to payment services"),
                onTap: () {
                  Navigator.pop(context);
                }
              ),
              Divider(
                color: Colors.grey[400],
              ),
              new ListTile(
                leading: Icon(Icons.bug_report),
                title: Text("Report an issue"),
                onTap: () {
                  Navigator.pop(context);
                }
              )
          ],
        ),
    );
  }
}
     

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   GoogleMapController mapController;

//   final LatLng _center = const LatLng(45.521563, -122.677433);

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('7 ! 0'),
//           backgroundColor: Colors.purple,
//         ),
//         drawer: Drawer(
//           child: new ListView(
//             children: <Widget>[
//               new UserAccountsDrawerHeader(
//                 accountName: new Text("User Name"),
//                 accountEmail: new Text("username@gmail.com"),
//                 currentAccountPicture: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   child: Text('UN'),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.navigation),
//                 title: Text("Start trip"),
//                 onTap: () {
//                   Navigator.push(context, new MaterialPageRoute(builder: (context) => new NavigationPage()));
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.attach_money),
//                 title: Text("Billing"),
//                 onTap: () {
//                   Navigator.push(context, new MaterialPageRoute(builder: (context) => new BillingPage()));
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.settings),
//                 title: Text("Settings"),
//                 onTap: () {
//                   Navigator.push(context, new MaterialPageRoute(builder: (context) => new SettingsPage()));
//                 }
//               ),
//               ListTile(
//                 leading: Icon(Icons.info),
//                 title: Text("Info"),
//                 onTap: () {
//                   Navigator.push(context, new MaterialPageRoute(builder: (context) => new InfoPage()));
//                 }
//               ),
//               ListTile(
//                 leading: Icon(Icons.people),
//                 title: Text("About"),
//                 onTap: () {
//                   Navigator.push(context, new MaterialPageRoute(builder: (context) => new AboutPage()));
//                 }
//               ),
//               Divider(
//                 color: Colors.grey[400]
//                 ),
//               ListTile(
//                 leading: Icon(Icons.contacts),
//                 title: Text("Open contacts"),
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.compare_arrows),
//                 title: Text("Link to payment services"),
//                 onTap: () {
//                   Navigator.pop(context);
//                 }
//               ),
//               Divider(
//                 color: Colors.grey[400],
//               ),
//               ListTile(
//                 leading: Icon(Icons.bug_report),
//                 title: Text("Report an issue"),
//                 onTap: () {
//                   Navigator.pop(context);
//                 }
//               )
//              ],
//             ),
//           ),
//         body: GoogleMap(
//           onMapCreated: _onMapCreated,
//           initialCameraPosition: CameraPosition(
//             target: _center,
//             zoom: 11.0,
//           ),
//         ),
//       ),
//     );
//   }
// }