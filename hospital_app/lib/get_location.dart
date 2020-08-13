import 'package:covid_hospital_app/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:location/location.dart' as loc;
import 'package:location_permissions/location_permissions.dart';

import 'api.dart';
import 'hospital_results.dart';

class GetLocationHome extends StatefulWidget {
  @override
  _GetLocationHomeState createState() => _GetLocationHomeState();
}

class _GetLocationHomeState extends State<GetLocationHome> {
  final Geolocator geolocator = Geolocator();
  bool isLoading ;
  Position _position;
  String _address;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false ;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.grey[100],
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.grey[400],
      ),
      child: LoadingOverlay(
        opacity: 0.5,
        color: Colors.black,
        progressIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),
        isLoading: isLoading,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]),
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/vectors/location.svg',
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        clipBehavior: Clip.hardEdge,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey[400])
                        ),
                        onPressed: () async{
                          setState(() {
                            isLoading = true ;
                            print('Setting True');
                          });
                          await _getLocation();
                          setState(() {
                            isLoading = false;
                            print('Setting false');
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Detect Location    ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 18),
                                ),
                                Icon(
                                  Icons.my_location,
                                  color: Colors.grey[700],
                                  size: 20,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      FlatButton(
                        clipBehavior: Clip.hardEdge,
                        color: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await Login.signOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false);
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign Out    ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                Icon(
                                  FontAwesomeIcons.signOutAlt,
                                  color: Colors.white,
                                  size: 20,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  _getLocation() async {
    ServiceStatus serviceStatus = await LocationPermissions().checkServiceStatus();
    if (serviceStatus != ServiceStatus.enabled) {
      //await LocationPermissions().openAppSettings();
      final location = loc.Location();
      await location.requestService();
      serviceStatus = await LocationPermissions().checkServiceStatus();
      if(serviceStatus != ServiceStatus.enabled) {
        return;
      }
    }
    await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) async{
      _position = position;
      await _getAddressFromLatLng();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HospitalResultsPage(position: _position, address: _address)));
      setState(() {
        isLoading = false ;
      });
    }).catchError((e){
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
//      List<Placemark> p = await geolocator.placemarkFromCoordinates(
//          _position.latitude, _position.longitude);
//
//      Placemark place = p[0];

      List<Address> addresses = await Geocoder.local
          .findAddressesFromCoordinates(
          Coordinates(_position.latitude, _position.longitude));
      _address = addresses.first.addressLine;
//      setState(() {
//        _address =
//        "${place.locality}, ${place.postalCode}, ${place.country}";
//
//      });
    } catch (e) {
      print(e);
    }
  }
//  _goToLogin() {
//    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
//  }
}
