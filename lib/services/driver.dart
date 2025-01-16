import 'dart:convert';

import 'package:schoolsto/services/client.dart';

import 'end_point.dart';

class DriverService{
  static createDriver(Map<String,dynamic>body)async{
    var response=await DbBase.databaseRequest(driverCreate, DbBase.postRequest,body: body);
     return jsonDecode(response);
  }

  static getAllDrivers() async{
    var response=await DbBase.databaseRequest("$driver/all", DbBase.getRequest);
    return jsonDecode(response);
  }
  static getDriverById(String id) async{
    var response=await DbBase.databaseRequest("$driver/$id", DbBase.getRequest);
    return jsonDecode(response);
  }

  static createCar({required Map<String, dynamic> body}) async{
    var response=await DbBase.databaseRequest(vehicleAdd, DbBase.postRequest,body: body);
    return jsonDecode(response);
  }

  static assignDriverToCar({required String driverId, required carId})async{
    var response=await DbBase.databaseRequest("$assignVehicle/$driverId/$carId", DbBase.putRequest);
    return jsonDecode(response);

  }
  static updateCurrentLocation({String? id, required double latitude, required double longitude, String? name})async {
    var response = await DbBase.databaseRequest(
        "$driver/updateLocation/$id/$latitude/$longitude/$name",
        DbBase.putRequest);
    return jsonDecode(response);
  }


}