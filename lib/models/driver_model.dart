import 'dart:convert';

import 'package:schoolsto/models/school_model.dart';
import 'package:schoolsto/models/vehicle_model.dart';

class DriverModel {
  String? id;
  String? email;
  String? fullname;
  String? phoneNumber;
  String? avator;
  String? type;
  String? locationName;
  VehicleModel? vehicle;
  SchoolModel? school;

  DriverModel(
      {this.email,
      this.fullname,
      this.avator,
      this.type,
      this.locationName,
      this.vehicle,
      this.school,
      this.phoneNumber,
      this.id});
  factory DriverModel.fromJson(Map<String,dynamic>json)=>DriverModel(
    email: json["email"],
    id: json["id"],
    fullname: json["fullName"],
    avator: json["avator"],
    type: json["type"],
    phoneNumber: json["phoneNumber"],
    locationName: json["locationName"],
    vehicle:json["vehicle"]==null?null: VehicleModel.fromJson(json["vehicle"]),
  );

}
