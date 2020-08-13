import 'package:intl/intl.dart';

class Hospital {
  final String id;
  final String name;
  final String website;
  final String address;
  final String areaPinCode;
  final String phoneNo;
  final String lastUpdated;
  final double latitude;
  final double longitude;
//  final List<dynamic> coordinates;
  final List<dynamic> beds;

  Hospital({
    this.website,
    this.address,
    this.id,
    this.name,
    this.areaPinCode,
    this.beds,
    this.latitude,
    this.longitude,
    this.lastUpdated,
    this.phoneNo,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json["_id"],
      name: json["name"],
      website: json["email"],
      address: json["address"],
      latitude: json["location"]["latitude"],
      longitude: json["location"]["longitude"],
      areaPinCode: json["area_pin_code"],
      phoneNo: json["phone"],
      lastUpdated: json['lastUpdatedAt'] != null
          ? DateFormat.yMMMd().format(DateTime.parse(json['lastUpdatedAt']))
          : "Unknown",
      beds: json["beds"],
    );
  }
}