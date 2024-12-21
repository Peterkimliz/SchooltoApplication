import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schoolsto/models/driver_model.dart';
import 'package:schoolsto/models/student_model.dart';
import 'package:schoolsto/screens/driver/home/driver_map.dart';
import 'package:schoolsto/screens/driver/profile/driver_profile.dart';
import 'package:schoolsto/services/driver.dart';
import 'package:schoolsto/services/notification_service.dart';
import 'package:schoolsto/services/student.dart';
import 'package:schoolsto/widgets/common_text.dart';
import '../models/place_details.dart';
import '../screens/driver/home/driver_home.dart';
import '../utils/constants/constants.dart';
import '../utils/functions.dart';
import 'AuthenticationController.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
class Drivercontroller extends GetxController {
  Rxn<File>? pickedImage = Rxn(null);
  RxBool loadingDrivers = RxBool(false);
  RxBool loadingStudents = RxBool(false);
  RxBool loadingDriver = RxBool(false);
  RxList<DriverModel> drivers = RxList([]);
  RxList<StudentModel> students = RxList([]);
  RxInt accountType = RxInt(0);
  RxInt currentIndex = RxInt(0);
  List pages = [DriverMap(), DriverProfile()];
  TextEditingController textEdittingControllerName = TextEditingController();
  TextEditingController textEdittingControllerLocation =
  TextEditingController();
  TextEditingController textEdittingControllerPhone = TextEditingController();
  TextEditingController textEdittingControllerVehiclePlate =
  TextEditingController();
  TextEditingController textEdittingControllerVehicleType =
  TextEditingController();
  GlobalKey<FormState> driverformKey = GlobalKey();
  GlobalKey<FormState> formKeyCar = GlobalKey();



  Rxn<Position> currentPosition = Rxn(null);
  Rxn<PlaceDetail> currentPlaceDetails = Rxn(null);
  final Completer<GoogleMapController> controller = Completer<GoogleMapController>();
  RxSet<Marker> markers = RxSet({});
  Future<Position> checkLocationPremission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (!serviceEnabled) {
      // do what you want
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Please location permission');

        await Geolocator.openAppSettings();

        throw '';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw "language lbl Location Permission Denied Permanently, please enable it from setting";
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      return value;
    }).catchError((e) async {
      return await Geolocator.getLastKnownPosition().then((value) async {
        if (value != null) {
          return value;
        } else {
          throw "lbl Enable Location";
        }
      }).catchError((e) {
        print(e.toString());
      });
    });
  }
  getCurrentLocation() async {
    Position position = await checkLocationPremission();
    currentPosition.value = position;
    // final GoogleMapController controllers = await controller.future;
    // await controllers.animateCamera(CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //       // bearing: 192.8334901395799,
    //         target: LatLng(currentPosition.value!.latitude, currentPosition.value!.longitude),
    //         // tilt: 59.440717697143555,
    //         zoom: 14)));
    print("Your Current position is ${position.toJson()}");
  }

  getPlaceDetails(double latitude, double longitude) async {
    Get.dialog(
        barrierDismissible: false,
        Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: const Row(
              children: [
                Text("Getting Place details"),
                SizedBox(
                  width: 10,
                ),
                CircularProgressIndicator()
              ],
            ),
          ),
        ));
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$mapKey';
    final response = await http.get(Uri.parse(url));
    Get.back();
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      PlaceDetail placeDetail = PlaceDetail(
        address: responseData["results"][0]["formatted_address"],
        latitude: responseData["results"][0]["geometry"]["location"]["lat"],
        longitude: responseData["results"][0]["geometry"]["location"]["lng"],
        name: responseData["results"][0]["formatted_address"],
      );
      currentPlaceDetails.value = placeDetail;
    } else {
      throw Exception("failed to load place Details");
    }
  }


  void getMarkers() async {
    BitmapDescriptor sourceIcon =await BitmapDescriptor.asset(
        ImageConfiguration.empty, "assets/images/marker.png");

    for (StudentModel studentModel in students) {
      markers.add(Marker(
        onTap: (){

          showBottomSheet(context: Get.context!, builder: (_){
            return Container(
              height: 250,
              padding: const EdgeInsets.all(10),
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0.3, 0.3),
                          blurRadius: 0.1,
                          spreadRadius: 0.1)
                    ]),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/profile.png",
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              name: studentModel.fullName!.capitalize!,
                              fontFamily: "RedHatMedium",
                              textSize: 18,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CommonText(
                              name: studentModel.phone!,
                              fontFamily: "RedHatMedium",
                              textSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Icon(Icons.location_on),
                                const SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                  child: CommonText(
                                    name: studentModel.locationName!,
                                    fontFamily: "RedHatMedium",
                                    textSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    InkWell(
                      onTap: ()async {
                        final Uri phoneUri=Uri(scheme: 'tel', path: "${studentModel.phone}");

                        if(await canLaunchUrl(phoneUri)){
                          await launchUrl(phoneUri);
                        }else{
                          throw "Could not launch";
                        }

                      },
                      child: Icon(
                        Icons.phone,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        },
          markerId: MarkerId(studentModel.id!),
          icon: sourceIcon,
          position: LatLng(studentModel.latitude!, studentModel.longitude!),
          infoWindow: InfoWindow(title: studentModel.fullName)));
    }

    markers.refresh();

    print(
        "******************Markers length is ${markers.length}******************************");
  }













  Future pickImage({required int value, required bool upload}) async {
    Get.back();
    try {
      XFile? image = await ImagePicker().pickImage(
          source: value == 0 ? ImageSource.camera : ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      pickedImage?.value = imageTemp;
    } on PlatformException {
      Navigator.pop(Get.context!);
    }
  }

  saveDriverData({required BuildContext context}) async {

    try {
      if (driverformKey.currentState!.validate()) {
        Map<String, dynamic> body = {
          "fullName": textEdittingControllerName.text,
          "phoneNumber": textEdittingControllerPhone.text,
          "type": accountType.value == 0 ? "freelancer" : "school",
          "id": Get.find<AuthenticationController>()
              .loggedInUserData
              .value!
              .userId,
          "email": Get.find<AuthenticationController>()
              .loggedInUserData
              .value!
              .email,
          "locationName": currentPlaceDetails.value!.name,
          "latitude": currentPlaceDetails.value!.latitude,
          "longitude": currentPlaceDetails.value!.longitude
        };

        showDefaultGetDialog(message: "Saving your data...");
        var response = await DriverService.createDriver(body);
        Get.back();

        if (response["message"] != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: CommonText(
              name: response["message"],
              textColor: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.red,
          ));
        }
        else {
          saveCreatedAccount();
          Get.back();
          getDriverById(Get.find<AuthenticationController>()
              .loggedInUserData
              .value!
              .userId);

          Get.to(() => DriverHome());
        }
      }
    } catch (e) {
      print("error is $e");
      Get.back();
    }
  }

  bool validateData() {
    if (textEdittingControllerName.text.trim().isEmpty ||
        textEdittingControllerPhone.text.trim().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  getAllDrivers() async {
    try {
      drivers.clear();
      loadingDrivers.value = true;
      List response = await DriverService.getAllDrivers();
      loadingDrivers.value = false;
      if (response.isNotEmpty) {
        List<DriverModel> drive =
            response.map((e) => DriverModel.fromJson(e)).toList();
        drivers.assignAll(drive);
      }
    } catch (e) {
      loadingDrivers.value = false;
      print("error is $e");
    }
  }

  getDriverById(String id) async {
    try {
      AuthenticationController authenticationController =
          Get.find<AuthenticationController>();
      drivers.clear();
      loadingDriver.value = true;
      var response = await DriverService.getDriverById(id);
      loadingDriver.value = false;
      if (response.isNotEmpty) {
        DriverModel drive = DriverModel.fromJson(response);
        authenticationController.currentDriver.value = drive;
      }
    } catch (e) {
      loadingDriver.value = false;
      print("error is $e");
    }
  }

  saveCar() async {
    try {
      if (formKeyCar.currentState!.validate()) {
        Map<String, dynamic> body = {
          "vehicleType": textEdittingControllerVehicleType.text,
          "vehiclePlate": textEdittingControllerVehiclePlate.text
        };
        showDefaultGetDialog(message: "Saving your data...");
        var response = await DriverService.createCar(body: body);

        if (response["message"] != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: CommonText(
              name: response["message"],
              textColor: Colors.white,
            ),
            backgroundColor: Colors.red,
          ));
        } else {
          var responseData = await DriverService.assignDriverToCar(
              driverId:
                  Get.find<AuthenticationController>().currentDriver.value!.id!,
              carId: response["id"]);
          DriverModel driverModel = DriverModel.fromJson(responseData);
          Get.find<AuthenticationController>().currentDriver.value =
              driverModel;
          Get.back();
          textEdittingControllerVehiclePlate.clear();
          textEdittingControllerVehicleType.clear();

        }
      }
      Get.back();
    } catch (e) {
      Get.back();
      print("Error is $e");
    }
  }



  getStudents() async {
    try {
      loadingStudents.value = true;
      String id = Get.find<AuthenticationController>().currentDriver.value!.id!;
      List response = await StudentService.getStudentsByDriver(id: id);

      List<StudentModel> std =
          response.map((e) => StudentModel.fromJson(e)).toList();
      students.assignAll(std);
      loadingStudents.value = false;
    } catch (e) {
      loadingStudents.value = false;
      print("error is $e");
    }
  }

  getStudentsByDriverAndLocation(
      {required double longitude, required double latitude}) async {

    try {
      String id = Get.find<AuthenticationController>().currentDriver.value!.id!;
      List response = await StudentService.getStudentsByDriverAndLocation(
          id: id, latitude: latitude, longitude: longitude);
      List<StudentModel> std =
          response.map((e) => StudentModel.fromJson(e)).toList();
      for (StudentModel studentModel in std) {
        NotificationService.sendChatNotification(
            email: studentModel.email!, message: "Driver is near your home");
      }

    } catch (e) {
      print("error Occurred is $e");
    }
  }
}
