import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:get/get.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class DriverMap extends StatefulWidget {
  DriverMap({super.key});

  @override
  State<DriverMap> createState() => _DriverMapState();
}

class _DriverMapState extends State<DriverMap> {
  Drivercontroller drivercontroller = Get.put(Drivercontroller());
  late Timer _timer;
  late GoogleMapController mapController;

  @override
  void initState() {
    getCurrentLocationAndAnimate();

    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) async {
      getCurrentLocationAndAnimate();
    });

    super.initState();
  }

  void getCurrentLocationAndAnimate() async {
    await drivercontroller.getCurrentLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(drivercontroller.currentPosition.value!.latitude,
            drivercontroller.currentPosition.value!.longitude),
        zoom: 14.0)));

    if(drivercontroller.onlineOfflineStatus.value){
      drivercontroller.getStudentsByDriverAndLocation(
          longitude: drivercontroller.currentPosition.value!.longitude,
          latitude: drivercontroller.currentPosition.value!.latitude);
      print("Hello there");
      drivercontroller.getMarkers();
    }

  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Obx(() => drivercontroller.currentPosition.value == null
              ? InkWell(
                  onTap: () {
                    drivercontroller.getCurrentLocation();
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: CommonText(
                                name: "Refresh",
                                fontFamily: "RedHatMedium",
                                fontWeight: FontWeight.bold,
                                textSize: 18,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      markers: drivercontroller.markers,
                      padding: const EdgeInsets.only(top: 300.0),
                      initialCameraPosition: CameraPosition(
                        target: LatLng(37.7749, -122.4194),
                        zoom: 14,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                    ),
                    Positioned(
                        top: 15,
                        right: 10,
                        child: Obx(()=>LiteRollingSwitch(
                          value: drivercontroller.onlineOfflineStatus.value,
                          textOn: "Online",
                          textOff: "Offline",
                          colorOff: Colors.red,
                          colorOn: Colors.green,
                          iconOff: Icons.remove_circle_outline,
                          iconOn: Icons.done,
                          textOffColor: Colors.white,
                          textOnColor: Colors.white,
                          textSize: 18.0,
                          onChanged: (state) {
                            drivercontroller.changeOnlineStatus(state);
                            print("The changed value is $state");
                          },
                          onTap: () {},
                          onDoubleTap: () {},
                          onSwipe: () {},
                        ))

                        // Switch(value: true, onChanged: (value) {})

                        )
                  ],
                ))),
    );
  }
}
