import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/controllers/student_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import '../../../utils/constants/constants.dart';

class StudentMap extends StatefulWidget {
  StudentMap({super.key});

  @override
  State<StudentMap> createState() => _StudentMapState();
}

class _StudentMapState extends State<StudentMap> {
  Timer? timer;
  final StudentController studentController = Get.put(StudentController());

  late GoogleMapController mapController;



  @override
  void initState() {
    getCurrentLocationAndAnimate();

    Timer.periodic(const Duration(minutes: 1), (Timer t) {
      print("Getting location");
      getCurrentLocationAndAnimate();
    });
    super.initState();
  }

  void getCurrentLocationAndAnimate() async {
    await studentController.getCurrentLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(studentController.currentPosition.value!.latitude,
            studentController.currentPosition.value!.longitude),
        zoom: 14.0)));
    studentController.getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Obx(()=>GoogleMap(
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            markers: studentController.markers,
            padding: const EdgeInsets.only(top: 300.0),
            polylines: Set<Polyline>.of(studentController.polylines.values),
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ))),
    );
  }




}
