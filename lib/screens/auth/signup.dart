import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:schoolsto/widgets/custom_button.dart';
import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key}) {
    authenticationController.clearTextFields();
  }

  final AuthenticationController authenticationController =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Form(
            key: authenticationController.signUpKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                CommonText(
                    name: "Sign Up",
                    textColor: Colors.black,
                    fontFamily: "RedHatMedium",
                    textSize: 20.0,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                CommonText(
                  name: "Create Account",
                  fontFamily: "RedHatMedium",
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: authenticationController
                      .textEdittingControllerSignUpEmail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => TextFormField(
                    obscureText:
                        authenticationController.signupPasswordObscurred.value,
                    controller: authenticationController
                        .textEdittingControllerSignUpPassword,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: InkWell(
                          onTap: () {
                            authenticationController
                                    .signupPasswordObscurred.value =
                                !authenticationController
                                    .signupPasswordObscurred.value;
                          },
                          child: Icon(
                            authenticationController
                                    .signupPasswordObscurred.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        )),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: 0,
                          activeColor: Colors.amber,
                          groupValue:
                              authenticationController.accountType.value,
                          onChanged: (val) {
                            authenticationController.accountType.value = val!;
                          },
                          title: const Text("Student"),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: 1,
                          activeColor: Colors.amber,
                          groupValue:
                              authenticationController.accountType.value,
                          onChanged: (val) {
                            authenticationController.accountType.value = val!;
                          },
                          title: const Text("Driver"),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: 2,
                          groupValue:
                              authenticationController.accountType.value,
                          activeColor: Colors.amber,
                          onChanged: (val) {
                            authenticationController.accountType.value = val!;
                          },
                          title: const Text("School"),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                 CustomButton(
                          title: "Sign Up",
                          onTap: () {
                            authenticationController.createAccount();
                          }),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText(
                      name: "Already have an account?",
                      textColor: Colors.black,
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Get.back();
                        authenticationController.clearTextFields();
                      },
                      child: CommonText(
                        name: "Sign In",
                        textDecoration: TextDecoration.underline,
                        textColor: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
