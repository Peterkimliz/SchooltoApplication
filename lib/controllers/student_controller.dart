import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:schoolsto/models/driver_model.dart';
import 'package:schoolsto/models/student_model.dart';
import 'package:schoolsto/screens/student/home/student_home.dart';
import 'package:schoolsto/screens/student/home/student_map.dart';
import 'package:schoolsto/screens/student/profile/student_profile.dart';
import 'package:schoolsto/services/end_point.dart';
import 'package:schoolsto/services/student.dart';
import 'package:schoolsto/utils/functions.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place_details.dart';
import '../utils/constants/constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class StudentController extends GetxController {
  Rxn<File>? pickedImage = Rxn(null);
  RxBool loadingUserDetails = RxBool(false);
  TextEditingController textEdittingControllerName = TextEditingController();
  TextEditingController textEdittingControllerParentName =
      TextEditingController();
  TextEditingController textEdittingControllerPhone = TextEditingController();
  TextEditingController textEdittingControllerLocation =
      TextEditingController();
  RxInt currentIndex = RxInt(0);
  List pages = [StudentMap(), StudentProfile()];
  GlobalKey<FormState> formKey = GlobalKey();

  Rxn<Position> currentPosition = Rxn(null);
  Rxn<PlaceDetail> currentPlaceDetails = Rxn(null);

  RxMap<PolylineId, Polyline> polylines = RxMap({});
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
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

  Future pickImage({required int value, required bool upload}) async {
    Get.back();
    try {
      XFile? image = await ImagePicker().pickImage(
          source: value == 0 ? ImageSource.camera : ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      pickedImage?.value = imageTemp;
      if (upload == true) {
        var url = await uploadImage();
        editUser(
            id: Get.find<AuthenticationController>().currentStudent.value!.id!,
            body: {"image": url});
      }
    } on PlatformException {
      Navigator.pop(Get.context!);
    }
  }

  saveStudent() async {
    try {
      if (formKey.currentState!.validate()) {
        Map<String, dynamic> body = {
          "id": Get.find<AuthenticationController>()
              .loggedInUserData
              .value!
              .userId,
          "email": Get.find<AuthenticationController>()
              .loggedInUserData
              .value!
              .email,
          "fullName": textEdittingControllerName.text,
          "phoneNumber": textEdittingControllerPhone.text,
          "parentName": textEdittingControllerParentName.text,
          "locationName": currentPlaceDetails.value!.name!,
          "latitude": currentPlaceDetails.value!.latitude!,
          "longitude": currentPlaceDetails.value!.longitude!
        };
        print(body);

        showDefaultGetDialog(message: "Saving your data");
        var response = await StudentService.createStudent(body);
        Get.back();
        print("response is $response");
        if (response["message"] != null) {
          print("hello");
          ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: CommonText(
              name: response["message"],
              fontWeight: FontWeight.bold,
              textColor: Colors.white,
            ),
            backgroundColor: Colors.red,
          ));
        } else {
          StudentModel studentModel = StudentModel.fromJson(response);
          Get.find<AuthenticationController>().currentStudent.value =
              studentModel;
          Get.off(() => StudentHome());
          clearControllers();
          saveCreatedAccount();
        }
      }
    } catch (e) {
      Get.back();

      print("error occurred is $e");
    }
  }

  clearControllers() {
    textEdittingControllerLocation.clear();
    textEdittingControllerPhone.clear();
    textEdittingControllerName.clear();
    textEdittingControllerParentName.clear();
  }

  getStudentById() async {
    try {
      AuthenticationController authenticationController =
          Get.find<AuthenticationController>();
      print(
          "Logged in is ${authenticationController.loggedInUserData.value!.userId}");
      loadingUserDetails.value = true;
      var response = await StudentService.getStudentById(
          authenticationController.loggedInUserData.value!.userId);
      StudentModel studentModel = StudentModel.fromJson(response);
      authenticationController.currentStudent.value = studentModel;
      print("response is $response");
      loadingUserDetails.value = false;
    } catch (e) {
      loadingUserDetails.value = false;

      print(e);
    }
  }

  assignDriver({required DriverModel driverModel}) async {
    try {
      AuthenticationController authenticationController =
          Get.find<AuthenticationController>();

      showDefaultGetDialog(message: "Attaching Driver...");
      var response = await StudentService.assignDriver(
        userId: authenticationController.loggedInUserData.value!.userId,
        driverId: driverModel.id,
      );
      print("Response ise $response");
      Get.back();
      getStudentById();
      Get.back();
    } catch (e) {
      Get.back();
      print("e");
    }
  }

  void detachDriver() async {
    try {
      AuthenticationController authenticationController =
          Get.find<AuthenticationController>();

      showDefaultGetDialog(message: "Detaching Driver...");
      var response = await StudentService.detachDriver(
        id: authenticationController.loggedInUserData.value!.userId,
      );
      print("Response ise $response");
      Get.back();
      getStudentById();
      Get.back();
    } catch (e) {
      Get.back();
      print("Error is $e");
    }
  }

  editUser({required String id, required Map<String, dynamic> body}) async {
    try {
      print("We are editting $body");
      showDefaultGetDialog(message: "Updating profile...");

      var response = await StudentService.editStudent(id: id, body: body);
      print("Response ise $response");
      Get.back();
      getStudentById();
    } catch (e) {
      print(e);
    }
  }

  Future<String?> uploadImage() async {
    try {
      showDefaultGetDialog(message: "Uploading Image");

      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      var storageRef =
          FirebaseStorage.instance.ref().child('studentImage/$imageName.jpg');
      var uploadTask = storageRef.putFile(pickedImage!.value!);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      Get.back();
      pickedImage!.value = null;
      return downloadUrl;
    } catch (e) {
      print("Error occurred is $e");
      return null;
    }
  }

  getPolyline() async {
    print("Hello peter iam called from here ");
    AuthenticationController authenticationController = Get.find<AuthenticationController>();
    await Get.find<Drivercontroller>().getDriverById(
        authenticationController.currentStudent.value!.driver!.id!);
    polylineCoordinates.clear();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: mapKey,
      request: PolylineRequest(
        origin: PointLatLng(
            authenticationController.currentStudent.value!.latitude!,
            authenticationController.currentStudent.value!.longitude!),
        destination: PointLatLng(
            authenticationController.currentDriver.value!.location!.latitude!,
            authenticationController.currentDriver.value!.location!.longitude!),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    polylines.refresh();
    getMarkers(authenticationController.currentDriver.value!);
  }

  void getMarkers(DriverModel driver) async {
    BitmapDescriptor sourceIcon = await BitmapDescriptor.asset(
        ImageConfiguration.empty, "assets/images/bus-station.png",
        height: 50, width: 50);

    markers.add(Marker(
        onTap: () {},
        markerId: MarkerId(driver.id!),
        icon: sourceIcon,
        position:
            LatLng(driver.location!.latitude!, driver.location!.longitude!),
        infoWindow: InfoWindow(title: driver.fullname)));

    markers.refresh();

    print(
        "******************Markers length is ${markers.length}******************************");
  }
}
