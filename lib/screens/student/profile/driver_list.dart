import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:schoolsto/controllers/student_controller.dart';
import 'package:schoolsto/models/driver_model.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:get/get.dart';

class DriverList extends StatelessWidget {
  DriverList({super.key});

  final Drivercontroller drivercontroller = Get.find<Drivercontroller>();
  final StudentController studentController = Get.find<StudentController>();

  @override
  Widget build(BuildContext context) {
    drivercontroller.getAllDrivers();
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: CommonText(
          name: "Drivers",
          fontFamily: "RedHatMedium",
        ),
      ),
      body: Obx(() {
        return drivercontroller.loadingDrivers.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : drivercontroller.drivers.isEmpty
                ? Center(
                    child: CommonText(
                      name: "No available Drivers",
                      textSize: 20,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: drivercontroller.drivers.length,
                    itemBuilder: (context, index) {
                      DriverModel driverModel =
                          drivercontroller.drivers.elementAt(index);
                      return InkWell(
                        onTap: () {
                          studentController.assignDriver(driverModel:driverModel);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 10, left: 10, right: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.2, 0.2),
                                    blurRadius: 0.7)
                              ]),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  "assets/images/profile.png",
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      name:
                                          driverModel.fullname!.capitalize!,
                                      fontFamily: "RedHatMedium",
                                    ),
                                    CommonText(
                                      name: driverModel.phoneNumber!,
                                      fontWeight: FontWeight.bold,
                                      textSize: 12,
                                    ),
                                    CommonText(
                                      name: driverModel.email!,
                                    ),
                                    SizedBox(height: 3,),
                                    Row(

                                      children: [
                                        const Icon(Icons.location_on),
                                        CommonText(
                                            name: driverModel.locationName!)
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
      }),
    );
  }
}
