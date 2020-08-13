import 'dart:convert';
import 'package:covid_hospital_app/alert.dart';
import 'package:covid_hospital_app/data_model.dart';
import 'package:covid_hospital_app/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Login {

  static FlutterSecureStorage storage = FlutterSecureStorage();
  static String baseUrl = 'https://covid-19-hospital-node.herokuapp.com/user';
  static User user = User();

//  static String prefix = '/user';

  static Future<String> jwtOrEmpty() async {
    String jwt = await storage.read(key: "jwt");
    return jwt;
  }

  static Future<dynamic> signInSilently() async {
    String jwt = await jwtOrEmpty();
    if (jwt == null)
      return "Unauthenticated";
    else {
      final res = await http.get(
          baseUrl, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt',
      });
      print(res.body);
      if (res.statusCode == 200)
        return jsonDecode(res.body)['data'];
      return "Unauthenticated";
    }
}

  static Future<dynamic> signIn(String email, String password, BuildContext context) async {
    var res = await http.post(
        baseUrl + '/authenticate',
        body: {
          "email": email,
          "password": password
        }
    );
    print(res.statusCode.toString());
    print(res.body);
    if (res.statusCode == 200) {
      var jwt = await jwtOrEmpty();
      if (jwt != null)
        await storage.delete(key: "jwt");
      await storage.write(
          key: "jwt", value: jsonDecode(res.body)['data']['access_token']);
      return jsonDecode(res.body)['data']['user'];
    }
    try {
      String errMsg = jsonDecode(res.body)['message'];
      String errReason = jsonDecode(res.body)['data'];
      await dialog(context, errReason, errMsg);
    } catch (e) {
      await dialog(context, res.body ?? e.toString(), "Error");
      // TODO
    }
    return null;
  }

  static Future<dynamic> signUp(String name, String email, String phone,
      String password, BuildContext context) async {
    var res = await http.post(
        baseUrl,
        body: {
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
        }
    );
    print(res.body.toString());
    if (res.statusCode == 200) {
      var jwt = await jwtOrEmpty();
      if (jwt != null)
        await storage.delete(key: "jwt");
      await storage.write(
          key: "jwt", value: jsonDecode(res.body)['access_token']);
      return jsonDecode(res.body)['data']['user'];
    }
    try {
      String errMsg = jsonDecode(res.body)['message'];
      String errReason = jsonDecode(res.body)['reason'][0];
      await dialog(context, errReason, errMsg);
    } catch (e) {
      await dialog(context, res.body ?? e.toString(), "Error");
      // TODO
    }
    return null;
  }

  static Future<void> signOut() async {
    user = null;
    String jwt = await jwtOrEmpty();
    if (jwt != null)
      await storage.delete(key: "jwt");
    // await http.put(baseUrl, headers: {"Authorization" : "Bearer " + jwt});
  }
}

class HospitalResults {

  static String baseUrl = 'https://covid-19-hospital-node.herokuapp.com/hospital';

  List<Hospital> hospitals;

  HospitalResults() {
    hospitals = [];
  }

  Future<void> fetchResults(Position position, BuildContext context) async {
    hospitals.clear();
    double x = position.latitude;
    double y = position.longitude;
    String pos = "?latitude=${x.toString()}&longitude=${y.toString()}";
    print('url is ' + baseUrl + pos);
    final res = await http.get(baseUrl + pos);
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      jsonData['data']['docs'].forEach((element) {
        hospitals.add(Hospital.fromJson(element));
      });
      // print(hospitals.length);
    } else {
      dialog(context, res.body, "Error " + res.statusCode.toString());
      print("Error + " + res.body);
    }
  }
}