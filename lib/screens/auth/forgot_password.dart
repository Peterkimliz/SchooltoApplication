import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/widgets/common_text.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/input_decoration.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final AuthenticationController authController =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          name: "Forgot password",
          fontWeight: FontWeight.bold,
          textSize: 20,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: authController.forgotKey,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: CommonText(
                  name: "Reset password by using \nyour email address",
                  fontWeight: FontWeight.bold,
                  textSize: 18.0,
                  textColor: Colors.black,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: authController.textEditingControllerSignInEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter email";
                  }
                  return null;
                },
                decoration: inputDecoration(
                    hint: "Enter emails address", label: "Email"),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  title: "Continue",
                  onTap: () {
                    authController.forgotPassword();
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
