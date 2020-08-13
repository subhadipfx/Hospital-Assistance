import 'package:animations/animations.dart';
import 'package:covid_hospital_app/api.dart';
import 'package:covid_hospital_app/login.dart';
import 'package:covid_hospital_app/tracking_screen.dart';
import 'package:covid_hospital_app/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'get_location.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashFactory: InkRipple.splashFactory,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal,
            ),
            TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal,
            ),
          }
        ),
        textTheme: GoogleFonts.montserratTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ViewSelector(),
    );
  }
}

class ViewSelector extends StatelessWidget {

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
      child: FutureBuilder<dynamic>(
        future: Login.signInSilently(),
        builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                ),
              );
            if (snapshot.data is Map) {
              Login.user = User.fromJson(snapshot.data);
              return GetLocationHome();
//              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => GetLocationHome()), (route) => false);
            }
            return LoginPage();
          }),
    );
  }
}
