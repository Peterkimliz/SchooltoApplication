import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:schoolsto/utils/functions.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:get/get.dart';

class EditPage extends StatelessWidget {
  EditPage({super.key}) {
    drivercontroller.assignFields(
        driver: authenticationController.currentDriver.value!);
  }

  final Drivercontroller drivercontroller = Get.find<Drivercontroller>();
  final AuthenticationController authenticationController =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4.0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: CommonText(
          name: "Edit",
          fontFamily: "RedHatMedium",
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.check,
                color: Colors.amber,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                name: "Name",
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
                name: "Phone",
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
              const SizedBox(height: 20),
              Obx(() => drivercontroller.accountType.value == 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          name: "Vehicle Type",
                          fontWeight: FontWeight.bold,
                        ),
                        TextFormField(
                          controller: drivercontroller
                              .textEdittingControllerVehicleType,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "eg. Mazda Cx",
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
                        ),
                        const SizedBox(height: 20),
                        CommonText(
                          name: "Vehicle Plate",
                          fontWeight: FontWeight.bold,
                        ),
                        TextFormField(
                          controller: drivercontroller
                              .textEdittingControllerVehiclePlate,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "eg. KAA 019D",
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
                        ),
                      ],
                    )
                  : SizedBox(height: 0, width: 0)),
              const SizedBox(height: 20),
              CommonText(
                name: "Location",
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 5),
              Row(
                children: [Icon(Icons.location_history_sharp)],
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
