import 'dart:convert';

import 'package:schoolsto/services/client.dart';

import 'end_point.dart';

class StudentService {
  static createStudent(Map<String, dynamic> body) async {
    var response = await DbBase.databaseRequest(
        createStudentUrl, DbBase.postRequest,
        body: body);
    return jsonDecode(response);
  }

  static getStudentById(String id) async {
    var response =
        await DbBase.databaseRequest("${student}/$id", DbBase.getRequest);
    return jsonDecode(response);
  }

  static assignDriver({required String userId, String? driverId}) async {
    var response = await DbBase.databaseRequest(
        "$student/assignDriver/$userId/$driverId", DbBase.putRequest);
    return jsonDecode(response);
  }

  static editStudent(
      {required String id, required Map<String, dynamic> body}) async {
    var response = await DbBase.databaseRequest(
        "$student/$id", DbBase.putRequest,
        body: body);
    return jsonDecode(response);
  }

  static getStudentsByDriver({required String id}) async {
    var response = await DbBase.databaseRequest(
        "$student/students/$id", DbBase.getRequest);
    return jsonDecode(response);
  }

  static getStudentsByDriverAndLocation(
      {required String id,
      required double latitude,
      required double longitude}) async {
    var response = await DbBase.databaseRequest(
        "$student/geomap/$id?isSubScribed=true&latitude=$latitude&longitude=$longitude&radius=500",
        DbBase.getRequest);
    return jsonDecode(response);
  }

  static updateSubStatus({String? id, required bool status}) async {
    var response = await DbBase.databaseRequest(
        "$student/subscription/$id", DbBase.putRequest,
        body: {"subsribed": status});
    return jsonDecode(response);
  }

  static detachDriver({required String id}) async {
    var response = await DbBase.databaseRequest(
        "$student/detachDriver/$id", DbBase.putRequest);
    return jsonDecode(response);
  }
}
