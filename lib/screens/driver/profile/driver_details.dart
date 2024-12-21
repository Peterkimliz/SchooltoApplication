import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:schoolsto/utils/functions.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:get/get.dart';
import 'package:schoolsto/widgets/custom_button.dart';
import 'package:geolocator/geolocator.dart';


class DriverDetails extends StatelessWidget {
  DriverDetails({super.key});
  final Drivercontroller drivercontroller = Get.find<Drivercontroller>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: drivercontroller.driverformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Obx(
                        () => ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: drivercontroller.pickedImage!.value != null
                              ? Image.file(
                                  File(drivercontroller.pickedImage!.value!.path),
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
                            imageDialog(page: "driver");
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
                  name: "Name *",
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: drivercontroller.textEdittingControllerName,
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
                  name: "Phone *",
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: drivercontroller.textEdittingControllerPhone,
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
                name: "Location *",
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 5),
              Row(
                    children: [
                      Expanded(
                          child:TextFormField(
                            enabled: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Location is required";
                              }
                              return null;
                            },
                            controller: drivercontroller
                                .textEdittingControllerLocation,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
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
                          )
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: ()async {
                            Position position = await drivercontroller
                                .checkLocationPremission();
                            await drivercontroller.getPlaceDetails(
                                position.latitude, position.longitude);
                            drivercontroller.textEdittingControllerLocation
                                .text = drivercontroller
                                .currentPlaceDetails.value?.address ??
                                "";

                          },
                          child: const Icon(Icons.my_location)),
                    ],
                  ),

            const SizedBox(height: 30),
                const SizedBox(height: 10),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: 0,
                          activeColor: Colors.amber,
                          groupValue: drivercontroller.accountType.value,
                          onChanged: (val) {
                            drivercontroller.accountType.value = val!;
                          },
                          title: Text("Freelancer"),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: 1,
                          activeColor: Colors.amber,
                          groupValue: drivercontroller.accountType.value,
                          onChanged: (val) {
                            drivercontroller.accountType.value = val!;
                          },
                          title: Text("School"),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                    title: "Continue",
                    onTap: () {
                      drivercontroller.saveDriverData(context:context);
                    })
              ],
            ),
          ),
        ),
      )),
    );
  }
}
