import 'dart:io';
import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/student_controller.dart';
import 'package:get/get.dart';
import 'package:schoolsto/utils/functions.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:schoolsto/widgets/custom_button.dart';
import 'package:geolocator/geolocator.dart';

class StudentDetails extends StatelessWidget {
  StudentDetails({super.key});
  final StudentController studentController = Get.find<StudentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: studentController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Obx(
                        () => ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: studentController.pickedImage!.value != null
                              ? Image.file(
                                  File(studentController
                                      .pickedImage!.value!.path),
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/profile.png",
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: -10,
                        child: InkWell(
                          onTap: () {
                            imageDialog(page: 'student');
                          },
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.amber,
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CommonText(
                  name: "Name",
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: studentController.textEdittingControllerName,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "eg. john doe",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      )),
                ),
                const SizedBox(height: 10),
                CommonText(
                  name: "Phone",
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: studentController.textEdittingControllerPhone,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Phone is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "eg. 0782000000",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      )),
                ),
                const SizedBox(height: 10),
                CommonText(
                  name: "Parent Name",
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller:
                      studentController.textEdittingControllerParentName,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Parent Name is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "eg. john doe",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      )),
                ),
                const SizedBox(height: 10),
                CommonText(
                  name: "Location",
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      enabled: false,
                      controller:
                          studentController.textEdittingControllerLocation,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Location is required ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          // contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          hintText: "eg. nakuru,kenya",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          )),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () async {
                          Position position = await studentController
                              .checkLocationPremission();
                          await studentController.getPlaceDetails(
                              position.latitude, position.longitude);
                          studentController.textEdittingControllerLocation
                              .text = studentController
                                  .currentPlaceDetails.value?.address ??
                              "";
                        },
                        child: const Icon(Icons.my_location)),
                  ],
                ),
                const SizedBox(height: 30),
                CustomButton(
                    title: "Save",
                    onTap: () {
                      studentController.saveStudent();
                    })
              ],
            ),
          ),
        ),
      )),
    );
  }
}
