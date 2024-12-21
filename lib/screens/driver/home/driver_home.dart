import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:get/get.dart';

class DriverHome extends StatelessWidget {
  DriverHome({super.key});

  final Drivercontroller drivercontroller = Get.find<Drivercontroller>();
  final AuthenticationController authenticationController =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
            () => drivercontroller.pages[drivercontroller.currentIndex.value]),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
              currentIndex: drivercontroller.currentIndex.value,
              onTap: (value) {
                drivercontroller.currentIndex.value = value;
              },
              selectedItemColor: Colors.amber,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Profile")
              ]),
        ));
  }
}
