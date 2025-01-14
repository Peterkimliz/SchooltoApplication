import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:schoolsto/screens/auth/login.dart';
import 'package:schoolsto/screens/driver/profile/car_add.dart';
import 'package:schoolsto/screens/driver/profile/edit_page.dart';
import 'package:schoolsto/screens/driver/profile/students_page.dart';
import 'package:schoolsto/services/end_point.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:get/get.dart';

class DriverProfile extends StatelessWidget {
  DriverProfile({super.key});

  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Get.find<Drivercontroller>().loadingDriver.value
        ? const Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              ),
            ),
          )
        : authenticationController.currentDriver.value == null
            ? Scaffold(
                body: SafeArea(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () {
                          Get.find<Drivercontroller>().getDriverById(
                              authenticationController
                                  .loggedInUserData.value!.userId);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.refresh_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            CommonText(
                              name: "Refresh",
                              fontFamily: "RedHatMedium",
                              textSize: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              )
            : Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                "assets/images/profile.png",
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  name: authenticationController.currentDriver
                                      .value!.fullname!.capitalize!,
                                  textSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "RedHatMedium",
                                ),
                                const SizedBox(height: 5),
                                CommonText(
                                  name: authenticationController
                                      .currentDriver.value!.email!,
                                  textSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "RedHatMedium",
                                  textColor: Colors.grey,
                                ),
                              ],
                            ))
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      showDragHandle: true,
                                      backgroundColor: const Color(0XFFFFFFF1),
                                      elevation: 4,
                                      clipBehavior: Clip.antiAlias,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25),
                                      )),
                                      context: context,
                                      builder: (_) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          padding: EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                              color: Color(0XFFFFFFF9),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(0.4, 0.4),
                                                    spreadRadius: 0.6,
                                                    blurRadius: 0.4)
                                              ]),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              if (authenticationController
                                                          .currentDriver
                                                          .value!
                                                          .vehicle ==
                                                      null &&
                                                  authenticationController
                                                          .currentDriver
                                                          .value!
                                                          .type!
                                                          .toLowerCase() ==
                                                      "freelancer")
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                    Get.to(() => CarAdd(),
                                                        );
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.add),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      CommonText(
                                                        name: "Add Car",
                                                        fontFamily:
                                                            "RedHatMedium",
                                                        textSize: 30,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              if (authenticationController
                                                      .currentDriver
                                                      .value!
                                                      .vehicle !=
                                                  null)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CommonText(
                                                      name: "Vehicle Details",
                                                      fontFamily:
                                                          "RedHatMedium",
                                                      textSize: 18,
                                                      textDecoration:
                                                          TextDecoration
                                                              .underline,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    CommonText(
                                                      name:
                                                      "Vehicle type: ${authenticationController.currentDriver.value!.vehicle!.vehicleType!}",
                                                      fontFamily:
                                                      "RedHatMedium",
                                                      textSize: 18,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    CommonText(
                                                      name:
                                                          "Vehicle plate: ${authenticationController.currentDriver.value!.vehicle!.vehiclePlate!}",
                                                      fontFamily:
                                                          "RedHatMedium",
                                                      textSize: 18,
                                                    )
                                                  ],
                                                )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.directions_car),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CommonText(
                                          name: "Car Details",
                                          textSize: 18,
                                          fontFamily: "RedHatMedium",
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: InkWell(
                                onTap: (){
                                  Get.to(() => StudentsPage(),
                                     );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.people),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CommonText(
                                          name: "Students",
                                          textSize: 18,
                                          fontFamily: "RedHatMedium",
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => EditPage());
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.edit),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CommonText(
                                          name: "Edit Profile",
                                          textSize: 18,
                                          fontFamily: "RedHatMedium",
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: Get.context!,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: CommonText(
                                            name: "Log Out",
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "RedHatMedium",
                                            textSize: 20.0,
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: CommonText(
                                                  name: "Cancel".toUpperCase(),
                                                  fontFamily: "RedHatMedium",
                                                  fontWeight: FontWeight.bold,
                                                  textColor: Colors.red,
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                  authenticationController
                                                      .logout();
                                                },
                                                child: CommonText(
                                                  name: "Okay".toUpperCase(),
                                                  fontFamily: "RedHatMedium",
                                                  fontWeight: FontWeight.bold,
                                                  textColor: Colors.amber,
                                                ))
                                          ],
                                        );
                                      });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.logout),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CommonText(
                                          name: "Logout",
                                          textSize: 18,
                                          fontFamily: "RedHatMedium",
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            ),
                            const Divider()
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
