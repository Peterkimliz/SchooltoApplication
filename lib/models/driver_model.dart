import 'dart:convert';

import 'package:schoolsto/models/school_model.dart';
import 'package:schoolsto/models/vehicle_model.dart';

class DriverModel {
  String? id;
  String? email;
  String? fullname;
  String? phoneNumber;
  String? image;
  String? type;
  String? locationName;
  DriverLocation? location;
  VehicleModel? vehicle;
  SchoolModel? school;

  DriverModel(
      {this.email,
      this.fullname,
      this.image,
      this.type,
      this.locationName,
      this.vehicle,
      this.school,
        this.location,
      this.phoneNumber,
      this.id});
  factory DriverModel.fromJson(Map<String,dynamic>json)=>DriverModel(
    email: json["email"],
    id: json["id"],
    location: DriverLocation.fromJson(json["location"]),
    fullname: json["fullName"],
    image: json["image"],
    type: json["type"],
    phoneNumber: json["phoneNumber"],
    locationName: json["locationName"],
    vehicle:json["vehicle"]==null?null: VehicleModel.fromJson(json["vehicle"]),
  );

}

class DriverLocation {
  double? latitude;
  double? longitude;


  DriverLocation(
      {this.latitude,
      this.longitude,
      });
  factory DriverLocation.fromJson(Map<String,dynamic>json)=>DriverLocation(
    latitude: json["latitude"],
    longitude: json["longitude"],
    
  );

}
