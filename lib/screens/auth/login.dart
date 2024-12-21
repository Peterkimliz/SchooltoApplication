import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/screens/auth/signup.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:schoolsto/widgets/custom_button.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key}) {
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
            key: authenticationController.signInKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                CommonText(
                    name: "Login",
                    textColor: Colors.black,
                    fontFamily: "RedHatMedium",
                    textSize: 20.0,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 20),
                CommonText(
                  name: "Welcome Back",
                  fontFamily: "RedHatMedium",
                ),
                SizedBox(height: 15),
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
               CustomButton(
                    title: "Login",
                    onTap: () {
                      authenticationController.signInAccount();
                    }),
                
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText(
                      name: "Don't have an account?",
                      textColor: Colors.black,
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Get.to(() => SignUp(),
                            duration: Duration(milliseconds: 4000),
                            transition: Transition.circularReveal);
                      },
                      child: CommonText(
                        name: "Sign Up",
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
