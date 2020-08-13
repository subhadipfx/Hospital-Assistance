import 'package:covid_hospital_app/get_location.dart';
import 'package:covid_hospital_app/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'api.dart';

class DashBoard extends StatelessWidget {
  final User user;

  DashBoard({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
          title: Text(user.name),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () async {
                await Login.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => GetLocationHome()),
                        (route) => false);
              },
            ),
//            FlatButton(
//              child: Text('Sign Out'),
//              onPressed: () async {
//                await Login.signOut();
//                Navigator.pushAndRemoveUntil(
//                    context,
//                    MaterialPageRoute(builder: (context) => GetLocationHome()),
//                    (route) => false);
//              },
//            ),
          ],
        ),
      ),
    );
  }
}
