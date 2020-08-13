import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class TrackingScreen extends StatefulWidget {
  final Position position;
  TrackingScreen({@required this.position});
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Geoflutterfire geo = Geoflutterfire();
  Geolocator geolocator = Geolocator();
  Firestore _firestore = Firestore.instance;
  Set<Marker> markers = {};
  bool isBooked = false;
  GoogleMapController googleMapController;
  bool isCompleteSearching = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isBooked = false;
    isCompleteSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Position>(
        future: _getLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<List<DocumentSnapshot>>(
              stream: geo.collection(collectionRef: _firestore.collection('locations')).within(center: geo.point(
                          latitude: snapshot.data.latitude,
                          longitude: snapshot.data.longitude),
                      radius: 200,
                      field: 'location'),
              builder: (context, stream) {
                if (stream.hasData && stream.data.length != 0 && !isCompleteSearching) {
                  GeoPoint position;
                  Timestamp timestamp;
                  stream.data.forEach((element) {
                    position = element.data['location']['geopoint'];
                    timestamp = element.data['timestamp'];
                    markers.add(Marker(
                      icon: BitmapDescriptor.defaultMarker,
                        markerId: MarkerId(element.documentID),
                        position: LatLng(position.latitude, position.longitude),
                        infoWindow: InfoWindow(
                            title: element.documentID,
                            snippet: timestamp.toDate().toLocal().toString())));
                    print('Added Marker ${element.documentID}');
                  });
                  isCompleteSearching = true ;
                }
                return FutureBuilder<Map<String, dynamic>>(
                    future: booking(),
                    builder: (context, bookingSnapshot) {
                      return SlidingSheet(
                        elevation: 8,
                        body: AnimatedPadding(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 1000),
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top,
                              bottom: MediaQuery.of(context).size.height * 0.3),
                          child: GoogleMap(
                            onMapCreated: (controller) => googleMapController = controller,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            rotateGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            //scrollGesturesEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  snapshot.data.latitude, snapshot.data.longitude),
                              zoom: 17,
                            ),
                            mapType: MapType.normal,
                            trafficEnabled: true,
                            markers: markers,
                          ),
                        ),
                        builder: (context, state) {
                          if (bookingSnapshot.hasData) {
                            if(bookingSnapshot.data['status'] == 'unbooked') {
                              return Container(
                                height:
                                MediaQuery.of(context).size.height * 0.3,
                                padding: EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 8),
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  'No Ambulance nearby',
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            }
                            else if (bookingSnapshot.data['status'] == 'booked')
                            return SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.075,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: AutoSizeText(
                                            bookingSnapshot.data['vehicleno'],
                                            style: TextStyle(fontSize: 30),
                                          )),
                                          CircleAvatar(
                                            backgroundColor: Colors.grey[300],
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.call,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 16,
                                          ),
                                          CircleAvatar(
                                            backgroundColor: Colors.grey[300],
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.share,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: MediaQuery.of(context).size.height * 0.075,
                                          backgroundColor: Colors.grey[300],
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.black,
                                            size: 100,
                                          ),
                                        ),
                                        Container(
                                          width: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              bookingSnapshot.data['firstname'],
                                              style: TextStyle(fontSize: 30),
                                            ),
                                            AutoSizeText(
                                              bookingSnapshot.data['lastname'],
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            AutoSizeText(
                                              bookingSnapshot.data['rating'].toString() + '⭐',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: [
                              LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.red),
                                backgroundColor: Colors.transparent,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                padding: EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 8),
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  'Booking Ambulance',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    });
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.black),
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> booking() async {
    while (markers.length > 0) {
      Marker finalVehicle = getNearestVehicle();
      bool success = await requestDriver(finalVehicle);
      if (success) {
        isBooked = true ;
        final driver = await getDriverDetails(finalVehicle.markerId.value);
        driver.addAll({'status' : 'booked'});
        print('booked: ' + driver.toString());
        final String driverID = finalVehicle.markerId.value;
//        googleMapController.animateCamera(
//            CameraUpdate.newLatLngBounds(
//            LatLngBounds(
//              northeast: LatLng(finalVehicle.position.latitude,
//                  finalVehicle.position.longitude),
//              southwest:
//                  LatLng(widget.position.latitude, widget.position.longitude),
//            ),
//            16));
        markers.add(finalVehicle);
        return driver;
      }
      if(markers.length == 0) {
        print('sending unbooked');
        return {'status': 'unbooked'};
      }
    }
    return null;
  }

  Future<bool>requestDriver(Marker vehicle) async{
    String driverID = vehicle.markerId.value ;
    await _firestore.collection('ongoingBookings').document(driverID).setData({'request' : 'waiting'});
    Stream<DocumentSnapshot> stream =
        _firestore.collection('ongoingBookings').document(driverID).snapshots();
    Timer timer = Timer.periodic(Duration(seconds: 30), (timer) async{
      await _firestore
          .collection('ongoingBookings')
          .document(driverID)
          .updateData({'request': 'unaccepted'});
    });
    await for (final value in stream) {
      if (value.data['request'] == 'accepted') {
        timer.cancel();
        return true;
      } else if (value.data['request'] == 'rejected') {
        timer.cancel();
        return false;
      }
      else if (value.data['request'] == 'unaccepted') {
        timer.cancel();
        return false ;
      }
    }
    return false;
  }

  Future<Map<String, dynamic>> getDriverDetails(String driverID) async {
    DocumentSnapshot driver = await _firestore.collection('drivers').document(driverID).get();
    return driver.data;
  }

  getNearestVehicle() {
    final point = geo.point(latitude: widget.position.latitude, longitude: widget.position.longitude);
    double finalDistance =  point.distance(lat: markers.elementAt(0).position.latitude, lng: markers.elementAt(0).position.longitude);
    Marker finalVehicle = markers.elementAt(0);
    markers.forEach((element) {
      var distance = point.distance(lat: element.position.latitude, lng: element.position.longitude);
      if(distance < finalDistance) {
        finalDistance = distance;
        finalVehicle = element;
      }
    });
    markers.remove(finalVehicle);
    return finalVehicle;
  }

  Future<Position> _getLocation() async {
    return widget.position;
  }
}
