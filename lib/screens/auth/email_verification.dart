import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/widgets/common_text.dart';

import '../../utils/colors.dart';

class EmailVerification extends StatelessWidget {
  final bool isForgotPassword;

  EmailVerification({super.key, this.isForgotPassword = false});

  final AuthenticationController authController =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          name: "Verify Email",
          fontWeight: FontWeight.bold,
          textSize: 20.0,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CommonText(
              name: "Verification Code",
              fontWeight: FontWeight.bold,
              textSize: 18.0,
              textColor: Colors.black,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  const TextSpan(
                      text:
                          '6-digits pin has been sent to your\n email address '),
                  TextSpan(
                    text: authController.loggedInUserData.value?.type ==
                            "student"
                        ? ' ${authController.currentStudent.value?.email ?? authController.textEditingControllerSignInEmail.text}'
                        : ' ${authController.currentDriver.value?.email ?? authController.textEditingControllerSignInEmail.text}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            OtpTextField(
              numberOfFields: 6,
              borderColor: Colors.black,
              fillColor: Colors.grey.withOpacity(0.2),
              focusedBorderColor: mainColor,
              filled: true,
              enabledBorderColor: mainColor.withOpacity(0.3),
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              onSubmit: (String verificationCode) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Verification Code"),
                        content: Text('Code entered is $verificationCode'),
                        actions: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: CommonText(
                              name: "Cancel",
                              fontWeight: FontWeight.bold,
                              textColor: mainColor,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                              authController.verifyOtpCode(
                                  verificationCode: verificationCode,
                                  isForgotPassword: isForgotPassword);
                            },
                            child: CommonText(
                              name: "Okay",
                              fontWeight: FontWeight.bold,
                              textColor: Colors.blue,
                            ),
                          )
                        ],
                      );
                    });
              }, // end onSubmit
            ),
            const SizedBox(height: 20),
            Obx(
              () => authController.remainingDuration.value == 0
                  ? RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          const TextSpan(text: 'You can now resend the otp '),
                          TextSpan(
                              text: ' Resend',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                  fontSize: 18),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  authController.resendCode(
                                      email: authController.loggedInUserData
                                                  .value?.type ==
                                              "student"
                                          ? authController
                                              .currentStudent.value!.email!
                                          : authController
                                              .currentDriver.value!.email!);
                                }),
                        ],
                      ),
                    )
                  : Center(
                      child: CommonText(
                          name:
                              "Resend OTP in ${authController.remainingDuration.value}")),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
