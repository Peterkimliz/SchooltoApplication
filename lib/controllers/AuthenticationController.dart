import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:schoolsto/controllers/student_controller.dart';
import 'package:schoolsto/models/LoggedData.dart';
import 'package:schoolsto/models/driver_model.dart';
import 'package:schoolsto/models/student_model.dart';
import 'package:schoolsto/screens/driver/home/driver_home.dart';
import 'package:schoolsto/screens/driver/profile/driver_details.dart';
import 'package:schoolsto/screens/student/home/student_home.dart';
import 'package:schoolsto/services/auth.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/auth/login.dart';
import '../screens/student/student_details.dart';
import '../utils/functions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthenticationController extends GetxController {
  RxInt accountType = RxInt(0);

  Rxn<LoggedData> loggedInUserData = Rxn(null);
  Rxn<StudentModel> currentStudent = Rxn(null);

  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  GlobalKey<FormState> signInKey = GlobalKey<FormState>();

  RxBool signupPasswordObscurred = RxBool(true);
  TextEditingController textEdittingControllerSignUpEmail =
      TextEditingController();
  TextEditingController textEdittingControllerSignUpPassword =
      TextEditingController();

  Rxn<DriverModel> currentDriver=Rxn(null);

  createAccount() async {
    try {
      if (signUpKey.currentState!.validate()) {
        Map<String, dynamic> body = {
          "email": textEdittingControllerSignUpEmail.text,
          "password": textEdittingControllerSignUpPassword.text,
          "type": accountType.value == 0
              ? "student"
              : accountType.value == 1
                  ? "driver"
                  : "school"
        };


        showDefaultGetDialog(message:"Creating Account...");
        var response = await Auth.signnInUser(body);
        Get.back();
        if (response["message"] != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: CommonText(
              name: response["message"],
              textColor: Colors.white,
              fontWeight: FontWeight.bold,
              textSize: 20,
            ),
            backgroundColor: Colors.red,
          ));
        } else {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString("token", response["token"]);
          sharedPreferences.setString("userId", response["user"]["id"]);
          sharedPreferences.setString("type", response["user"]["type"]);
          sharedPreferences.setBool("accountCreated", false);
          sharedPreferences.setString("email", response["user"]["email"]);
          getUserDetails();
          OneSignal.login(response["user"]["email"]);

          if (response["user"]["type"] == "student") {
            Get.off(() => StudentDetails());
          } else if (response["user"]["type"] == "driver") {
            Get.off(() => DriverDetails());
          } else {}
        }
      }
    } catch (e) {
      Get.back();
      print(e);
    }
  }

  signInAccount() async {
    try {
      if (signInKey.currentState!.validate()) {
        Map<String, dynamic> body = {
          "email": textEdittingControllerSignUpEmail.text,
          "password": textEdittingControllerSignUpPassword.text
        };
        showDefaultGetDialog(message:"Logging  in ...");

        var response = await Auth.loginUser(body);
        Get.back();

        if (response["message"] != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: CommonText(
              name: response["message"],
              textColor: Colors.white,
              fontWeight: FontWeight.bold,
              textSize: 20,
            ),
            backgroundColor: Colors.red,
          ));
        } else {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString("token", response["token"]);
          sharedPreferences.setString("userId", response["user"]["id"]);
          sharedPreferences.setString("type", response["user"]["type"]);
          sharedPreferences.setBool(
              "accountCreated", response["user"]["accountCreated"]);
          sharedPreferences.setString("email", response["user"]["email"]);
          await getUserDetails();
          OneSignal.login(response["user"]["email"]);

          if (response["user"]["type"] == "student" &&
              response["user"]["accountCreated"] == false) {
            Get.off(() => StudentDetails());
          } else if (response["user"]["type"] == "driver" &&
              response["user"]["accountCreated"] == false) {

            Get.to(() => DriverDetails());
          } else {
            if (response["user"]["type"] == "student") {
              Get.find<StudentController>().getStudentById();

              Get.off(() => StudentHome());
            } else if (response["user"]["type"] == "driver") {
              await Get.find<Drivercontroller>().getDriverById(loggedInUserData.value!.userId!);
              await Get.find<Drivercontroller>().getStudents();

              Get.to(() => DriverHome());
            }
          }
        }
      }
    } catch (e) {
      Get.back();

      print("error is ${e.toString()}");
    }
  }

  getUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userId = sharedPreferences.getString("userId") ?? "";
    String type = sharedPreferences.getString("type") ?? "";
    String email = sharedPreferences.getString("email") ?? "";
    print("email is $email");
    print("email is $type");
    print("email is $userId");
    bool isLoggedIn = sharedPreferences.getBool("accountCreated") ?? false;
    LoggedData loggedData = LoggedData(userId: userId, accountCreated: isLoggedIn, type: type, email: email);
    loggedInUserData.value = loggedData;
  }

  void clearTextFields() {
    textEdittingControllerSignUpEmail.clear();
    textEdittingControllerSignUpPassword.clear();
    // signupPasswordObscurred.value = true;
  }

  void logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    AuthenticationController auth =Get.find<AuthenticationController>();
    auth.loggedInUserData.value=null;
    auth.currentDriver.value=null;
    auth.currentStudent.value=null;
    Get.find<StudentController>().currentIndex.value=0;
    Get.find<Drivercontroller>().currentIndex.value=0;
    Get.offAll(() => LoginPage());
  }
}
