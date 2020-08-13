import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data_model.dart';

class HospitalList extends StatelessWidget {

  final Hospital hospital ;
  HospitalList({@required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Container(
//      clipBehavior: Clip.hardEdge,
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(12),
//        side: BorderSide(color: Colors.grey[100]),
//      ),
//      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
//          Container(
//            height: 150,
//            width: double.infinity,
//            child: Image.asset(
//              'assets/png/hospital.png',
//              fit: BoxFit.cover,
//            ),
//            decoration: BoxDecoration(
//              color: Colors.white,
//              borderRadius: BorderRadius.circular(12),
//              border: Border.all(color: Colors.blue),
//            ),
//          ),
          InkWell(
            onTap: (){},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hospital.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          hospital.address,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => MapsLauncher.launchCoordinates(
                        hospital.latitude, hospital.longitude),
                    child: Icon(
                      Icons.place,
                      color: Colors.orange,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(thickness: 1, color: Colors.grey[200], height: 0, indent: 16, endIndent: 16,),
          InkWell(
            onTap: ()=> launch("tel::${hospital.phoneNo}"),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: Text(hospital.phoneNo, style: TextStyle(fontSize: 15),)),
                  Icon(Icons.call, color: Colors.blue, size: 30),
                ],
              ),
            ),
          ),
          Divider(thickness: 1, color: Colors.grey[200], height: 0, indent: 16, endIndent: 16,),
          InkWell(
            onTap: () => launch(hospital.website),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: Text(hospital.website, style: TextStyle(fontSize: 15),)),
                  Icon(FontAwesomeIcons.globeAmericas, color: Colors.green, size: 30,)
                ],
              ),
            ),
          ),
          Divider(thickness: 1, color: Colors.grey[200], height: 0, indent: 16, endIndent: 16,),
          InkWell(
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: hospital.beds.map((e) => Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Row(
                            children: [
                              Text(e['department'].toString().toUpperCase() + ' - ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                              //Container(width: 8,),
                              Text(e['available'].toString()),
                            ],
                                    ),
                                  ))
                              .toList()),
                    ),
                  ),
                  Icon(FontAwesomeIcons.bed, color: Colors.deepPurpleAccent, size: 30,),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Last Updated at: ' + hospital.lastUpdated,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Divider(
            thickness: 0.5,
            color: Colors.black,
            height: 32,
          ),
        ],
      ),
    );
  }
}
