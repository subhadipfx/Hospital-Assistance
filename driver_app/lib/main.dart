import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:location/location.dart';
import 'firemap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Driver App'),
          centerTitle: true,
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fisrtname = 'John';
  String lastname = 'Watson';
  String vehicleno = 'WB1234B56';
  double rating = 4.5 ;
  bool isLoading = false ;
  String driverID;
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'First Name'),
              onChanged: (value) => fisrtname = value,
            ),
            Container(
              height: 16,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Last Name'),
              onChanged: (value) => lastname = value,
            ),
            Container(
              height: 16,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Vehicle No'),
              onChanged: (value) => vehicleno = value,
            ),
            Container(
              height: 16,
            ),
            RaisedButton(
              onPressed: _getLocation,
              child: Text('Enter'),
            ),
          ],
        ),
      ),
    );
  }

  _getLocation() async {
    setState(() {
      isLoading = true;
    });
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    driverID = fisrtname + lastname + vehicleno;
    Firestore _firestore = Firestore.instance;
    await _firestore.collection('drivers').document(driverID).setData({
      'firstname' : fisrtname,
      'lastname' : lastname,
      'vehicleno' : vehicleno.toUpperCase(),
      'rating' : rating,
    });
    await _firestore.collection('ongoingBookings').document(driverID).setData({
      'request' : 'available',
    });
    setState(() {
      isLoading = false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => FireMap(locationData: _locationData, id: driverID)));
  }
}


