import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:schoolsto/controllers/student_controller.dart';
import 'package:schoolsto/screens/auth/email_verification.dart';
import 'package:schoolsto/screens/auth/login.dart';
import 'package:get/get.dart';
import 'package:schoolsto/screens/driver/home/driver_home.dart';
import 'package:schoolsto/screens/driver/profile/driver_details.dart';
import 'package:schoolsto/screens/student/home/student_home.dart';
import 'package:schoolsto/screens/student/student_details.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();
  Drivercontroller drivercontroller = Get.find<Drivercontroller>();
  StudentController studentController = Get.find<StudentController>();

  @override
  void initState() {
    Timer(
      const Duration(milliseconds: 4000),
      () async {
        await authenticationController.getUserDetails();
        if (authenticationController.loggedInUserData.value == null) {
          Get.off(() => LoginPage());
        } else if (authenticationController
            .loggedInUserData.value!.userId.isEmpty) {
          Get.off(() => LoginPage());
        } else if (authenticationController.loggedInUserData.value!.type ==
                "driver" &&
            authenticationController.loggedInUserData.value!.accountCreated ==
                false) {
          Get.off(() => DriverDetails());
        } else if (authenticationController
                .loggedInUserData.value?.emailVerified ==
            false) {
          // authenticationController.resendCode(
          //     email: authenticationController.loggedInUserData.value!.email);
          Get.off(() => EmailVerification());
        } else if (authenticationController.loggedInUserData.value!.type ==
                "student" &&
            authenticationController.loggedInUserData.value!.accountCreated ==
                false) {
          Get.off(() => StudentDetails());
        } else {
          print("hello iam logged in");
          if (authenticationController.loggedInUserData.value!.type ==
              "driver") {
            Get.off(() => DriverHome());
            await drivercontroller.getDriverById(
                authenticationController.loggedInUserData.value!.userId);
            drivercontroller.getStudents();
          } else if (authenticationController.loggedInUserData.value!.type ==
                  "student" &&
              authenticationController.loggedInUserData.value!.accountCreated ==
                  true) {
            studentController.getStudentById();
            Get.off(() => StudentHome());
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(125),
              child: Image.asset(
                "assets/images/logo.jpg",
                height: 250,
                width: 250,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
