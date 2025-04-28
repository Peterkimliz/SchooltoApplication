import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/widgets/common_text.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/input_decoration.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final AuthenticationController authController =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          name: "Create New Password",
          fontWeight: FontWeight.bold,
          textSize: 20.0,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: authController.forgotResetPasswordKey,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: CommonText(
                  name: "Set up New Password ",
                  fontWeight: FontWeight.bold,
                  textSize: 18.0,
                  textColor: Colors.black,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Obx(() => TextFormField(
                    obscureText: authController.obscurredResetPassword.value,
                    controller:
                        authController.textEditingControllerresetPassword,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter new password";
                      }
                      return null;
                    },
                    decoration: inputDecoration(
                      hint: "******",
                      label: "New Password",
                      suffixIcon: authController.obscurredResetPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      callBack: () {
                        authController.obscurredResetPassword.value =
                            !authController.obscurredResetPassword.value;
                      },
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              Obx(() => TextFormField(
                    obscureText: authController.obscurredConfirmPassword.value,
                    controller: authController
                        .textEditingControllerConfirmResetPassword,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Confirm Password";
                      }
                      if (authController.textEditingControllerresetPassword.text
                              .trim() !=
                          value.trim()) {
                        return "Password mismatched";
                      }
                      return null;
                    },
                    decoration: inputDecoration(
                      hint: "******",
                      label: "Confirm Password",
                      suffixIcon: authController.obscurredConfirmPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      callBack: () {
                        authController.obscurredConfirmPassword.value =
                            !authController.obscurredConfirmPassword.value;
                      },
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  title: "Continue",
                  onTap: () {
                    if (authController.forgotResetPasswordKey.currentState!
                        .validate()) {
                      authController.resetUserPassword(
                          email: authController
                              .textEditingControllerSignInEmail.text,
                          password: authController
                              .textEditingControllerresetPassword.text);
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
