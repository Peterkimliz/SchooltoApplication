import 'dart:async';

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
import '../screens/auth/email_verification.dart';
import '../screens/auth/login.dart';
import '../screens/auth/reset_password.dart';
import '../screens/student/student_details.dart';
import '../utils/functions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../widgets/custom_button.dart';

class AuthenticationController extends GetxController {
  RxInt accountType = RxInt(0);

  late Timer _timer;
  RxBool isResendEnabled = RxBool(false);
  RxInt duration = RxInt(180);
  RxInt remainingDuration = RxInt(0);

  Rxn<LoggedData> loggedInUserData = Rxn(null);
  Rxn<StudentModel> currentStudent = Rxn(null);

  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  GlobalKey<FormState> signInKey = GlobalKey<FormState>();

  RxBool signupPasswordObscurred = RxBool(true);
  TextEditingController textEdittingControllerSignUpEmail =
      TextEditingController();
  TextEditingController textEdittingControllerSignUpPassword =
      TextEditingController();
  Rxn<DriverModel> currentDriver = Rxn(null);
  GlobalKey<FormState> forgotKey = GlobalKey();

  TextEditingController textEditingControllerSignInEmail =
      TextEditingController();
  TextEditingController textEditingControllerSignUpEmail =
      TextEditingController();
  TextEditingController textEditingControllerConfirmResetPassword =
      TextEditingController();
  TextEditingController textEditingControllerresetPassword =
      TextEditingController();

  GlobalKey<FormState> forgotResetPasswordKey = GlobalKey();

  RxBool obscurredSignInPassword = RxBool(true);
  RxBool obscurredResetPassword = RxBool(true);
  RxBool obscurredConfirmPassword = RxBool(true);

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

        showDefaultGetDialog(message: "Creating Account...");
        var response = await Auth.signnInUser(body);
        print("the response is ${response}");
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
          showEmailDialog();
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString("token", response["token"]);
          sharedPreferences.setString("userId", response["user"]["id"]);
          sharedPreferences.setString("type", response["user"]["type"]);
          sharedPreferences.setBool("accountCreated", false);
          sharedPreferences.setBool(
              "emailVerified", response["user"]["emailVerified"]);
          sharedPreferences.setString("email", response["user"]["email"]);

          getUserDetails();
          OneSignal.login(response["user"]["email"]);
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
        showDefaultGetDialog(message: "Logging  in ...");
        var response = await Auth.loginUser(body);
        Get.back();
        print("the response is ${response}");

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
          sharedPreferences.setBool(
              "emailVerified", response["user"]["emailVerified"]);
          sharedPreferences.setString("email", response["user"]["email"]);
          await getUserDetails();
          OneSignal.login(response["user"]["email"]);
          if (response["user"]["type"] == "student" &&
              response["user"]["accountCreated"] == false) {
            Get.off(() => StudentDetails());
          } else if (response["user"]["type"] == "driver" &&
              response["user"]["accountCreated"] == false) {
            Get.off(() => DriverDetails());
          } else {
            if (response["user"]["type"] == "student") {
              Get.find<StudentController>().getStudentById();

              Get.off(() => StudentHome());
            } else if (response["user"]["type"] == "driver") {
              await Get.find<Drivercontroller>()
                  .getDriverById(loggedInUserData.value!.userId!);
              await Get.find<Drivercontroller>().getStudents();

              Get.off(() => DriverHome());
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
    bool emailVerified = sharedPreferences.getBool("emailVerified") ?? false;
    print("email is $email");
    print("email is $type");
    print("email is $userId");
    bool isLoggedIn = sharedPreferences.getBool("accountCreated") ?? false;
    LoggedData loggedData = LoggedData(
        emailVerified: emailVerified,
        userId: userId,
        accountCreated: isLoggedIn,
        type: type,
        email: email);
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
    AuthenticationController auth = Get.find<AuthenticationController>();
    auth.loggedInUserData.value = null;
    auth.currentDriver.value = null;
    auth.currentStudent.value = null;
    Get.find<StudentController>().currentIndex.value = 0;
    Get.find<Drivercontroller>().currentIndex.value = 0;
    Get.offAll(() => LoginPage());
  }

  forgotPassword() async {
    try {
      if (forgotKey.currentState!.validate()) {
        showDefaultGetDialog(message: "Sending otp");
        var response =
            await Auth.resendOtp(email: textEditingControllerSignInEmail.text);
        debugPrintMessage("The response is $response");
        Get.back();
        if (response["status"] == 404) {
          showDefaultSnackBar(message: response["message"], color: Colors.red);
        } else {
          showEmailDialog(isForgotPassword: true);
        }
      }
    } catch (e) {
      Get.back();
      debugPrintMessage("Error is $e");
    }
  }

  void startCountdown() {
    remainingDuration.value = duration.value;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingDuration.value > 0) {
        remainingDuration.value--;
        isResendEnabled.value = false;
      } else {
        // Countdown finished
        _timer.cancel();
        isResendEnabled.value = true;
      }
    });
  }

  resendCode({required String email, String? message}) async {
    print("The email is $email");
    try {
      showDefaultGetDialog(message: message ?? "Resending the  otp");
      var response = await Auth.resendOtp(email: email);
      debugPrintMessage("The response is $response");
      Get.back();
      if (response["statusCode"] == 404) {
        showDefaultSnackBar(message: response["message"], color: Colors.red);
      } else {
        startCountdown();
      }
    } catch (e) {
      Get.back();
      debugPrintMessage("The error is $e");
    }
  }

  resetUserPassword({required String email, required String password}) async {
    try {
      showDefaultGetDialog(message: "Updating password");
      var response = await Auth.resetUserPassword(
          body: {"email": email, "password": password});
      debugPrintMessage("The response is $response");
      Get.back();
      if (response["statusCode"] == 404) {
        showDefaultSnackBar(message: response["message"], color: Colors.red);
      } else {
        showDefaultSnackBar(message: response["message"], color: Colors.green);
        Get.offAll(() => LoginPage());
        textEditingControllerSignUpEmail.clear();
        textEditingControllerConfirmResetPassword.clear();
        textEditingControllerresetPassword.clear();
      }
    } catch (e) {
      Get.back();
      debugPrintMessage("The error is $e");
    }
  }

  void verifyOtpCode(
      {required String verificationCode,
      required bool isForgotPassword}) async {
    try {
      showDefaultGetDialog(message: "Verifying otp");
      var response = await Auth.verifyOtp(verificationCode);
      debugPrintMessage("The response is $response");
      Get.back();
      if (response["status"] == 200) {
        if (isForgotPassword) {
          Get.offAll(() => ResetPassword());
        } else {
          if (loggedInUserData.value!.type == "student") {
            Get.off(() => StudentDetails());
          } else if (loggedInUserData.value!.type == "driver") {
            Get.off(() => DriverDetails());
          }
        }
      } else {
        showDefaultSnackBar(message: response["message"]);
      }
    } catch (e) {
      Get.back();
      debugPrintMessage("Error is $e");
    }
  }

  showEmailDialog({bool isForgotPassword = false}) {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Verification your Email"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      const TextSpan(text: 'We have sent a verification Code '),
                      TextSpan(
                        text: loggedInUserData.value!.email.trim().isEmpty
                            ? textEditingControllerSignInEmail.text
                            : loggedInUserData.value?.email,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                    title: "Got It",
                    onTap: () {
                      Get.back();
                      Get.offAll(() => EmailVerification(
                            isForgotPassword: isForgotPassword,
                          ));
                      startCountdown();
                    })
              ],
            ),
          );
        });
  }
}
