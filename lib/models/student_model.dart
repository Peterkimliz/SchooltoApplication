import 'package:schoolsto/models/driver_model.dart';
import 'package:schoolsto/models/school_model.dart';
import 'package:schoolsto/screens/student/home/student_home.dart';

class StudentModel {
  String? id;
  String? email;
  String? fullName;
  String? image;
  String? phone;
  String? parentName;
  String? locationName;
  double? latitude;
  double? longitude;
  bool? subscribed;
  DriverModel? driver;
  SchoolModel? schoolModel;

  StudentModel(
      {this.email,
      this.id,
      this.fullName,
      this.latitude,
      this.locationName,
      this.longitude,
      this.parentName,
      this.phone,
      this.driver,
      this.schoolModel,
      this.image,
      this.subscribed});

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        id: json["id"],
        subscribed: json["subscribed"],
        image: json["image"] ?? "",
        phone: json["phoneNumber"],
        parentName: json["parentName"],
        email: json["email"],
        fullName: json["fullName"],
        locationName: json["locationName"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        driver: json["driver"] == null
            ? null
            : DriverModel.fromJson(json["driver"]),
        schoolModel: json["school"] == null
            ? null
            : SchoolModel.fromJson(json["school"]),
      );
}
