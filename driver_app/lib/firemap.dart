import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class FireMap extends StatefulWidget {
  final LocationData locationData;
  final String id;
  FireMap({@required this.locationData, @required this.id});
  @override
  State createState() => FireMapState();
}

class FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  Geoflutterfire geo = Geoflutterfire();
  Set<Marker> markers = {};
  GeoFirePoint myLocation ;
  Firestore _firestore = Firestore.instance;
  Stream stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myLocation = geo.point(latitude: widget.locationData.latitude, longitude: widget.locationData.longitude);
    upStream(myLocation);
    stream = _firestore.collection('ongoingBookings').document(widget.id).snapshots();
  }

  Future<void>upStream(GeoFirePoint myLocation) async {
    Firestore _firestore = Firestore.instance ;
    Geoflutterfire geo = Geoflutterfire();
    int i = 0;
    while (i<10) {
      await _firestore.collection('locations').document(widget.id).setData({
//        'name' : widget.id,
        'location': myLocation.data,
        'timestamp' : DateTime.now().toLocal(),
      });
      print('added location ${i++}');
      await Future.delayed(Duration(seconds: 5));
      Location location = Location();
      LocationData locationData = await location.getLocation();
      myLocation = geo.point(latitude: locationData.latitude, longitude: locationData.longitude);
    }
  }

  @override
  Widget build(context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.locationData.latitude, widget.locationData.longitude),
              zoom: 17),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          // Add little blue dot for device location, requires permission from user
          mapType: MapType.normal,
          trafficEnabled: true,
          markers: markers,
        ),
        StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data['request'] == 'waiting')
              return alertDialog();
            return Container();
          },
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _addMarker(widget.locationData);
    mapController = controller;
  }

  confirmationDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Icon(FontAwesomeIcons.bed),
        content: Text('Patient found. Accept ride?'),
        actions: [
          FlatButton(
            onPressed: () async{
              await _firestore.collection('ongoingBookings').document(widget.id).setData({'request' : 'accepted'});
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
          FlatButton(
            onPressed: () async{
              await _firestore.collection('ongoingBookings').document(widget.id).setData({'request' : 'rejected'});
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  Widget alertDialog() {
    return AlertDialog(
      title: Icon(FontAwesomeIcons.bed),
      content: Text('Patient found. Accept ride?'),
      actions: [
        FlatButton(
          onPressed: () async {
            await _firestore.collection('ongoingBookings').document(widget.id).setData({'request' : 'accepted'});
          },
          child: Text('Accept'),
        ),
        FlatButton(
          onPressed: () async {
            await _firestore.collection('ongoingBookings').document(widget.id).setData({'request' : 'rejected'});
          },
          child: Text('Decline'),
        ),
      ],
    );
  }

  _addMarker(LocationData locationData) async {
    BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(10, 10)), 'assets/ambulance.png');
    Marker marker = Marker(
      markerId: MarkerId("0"),
      icon: markerIcon,
      position: LatLng(locationData.latitude, locationData.longitude),
      infoWindow: InfoWindow(title: 'Magic Marker'),
    );
    setState(() {
      markers.add(marker);
    });
//    mapController.showMarkerInfoWindow(markers);
  }

//  _animateToUser() async {
//    Location location = new Location();
//    LocationData pos = await location.getLocation();
//    mapController.animateCamera(
//      CameraUpdate.newCameraPosition(CameraPosition(
//        target: LatLng(pos.latitude, pos.latitude),
//        zoom: 17.0,
//      )),
//    );
//    //_addMarker(pos);
//  }
}

