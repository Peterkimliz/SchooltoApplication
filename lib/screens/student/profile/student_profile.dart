import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/controllers/student_controller.dart';
import 'package:schoolsto/screens/student/profile/driver_list.dart';
import '../../../utils/functions.dart';
import '../../../widgets/common_text.dart';
import '../../auth/login.dart';
import '../../driver/profile/edit_page.dart';

class StudentProfile extends StatelessWidget {
  AuthenticationController authenticationController =
      Get.find<AuthenticationController>();


  StudentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return

      Obx(()=>  Get.find<StudentController>().loadingUserDetails.value
        ? const Scaffold(
          body: SafeArea(
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            Center(
              child: CircularProgressIndicator(),
            ),
                  ],
                ),
          ),
        )
        :authenticationController.currentStudent.value==null?
         Scaffold(
        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: InkWell(
                    onTap: (){
                      Get.find<StudentController>().getStudentById();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_outlined),
                        SizedBox(width: 5,),
                        CommonText(name: "Refresh",fontFamily: "RedHatMedium",textSize: 20,),

                      ],
                    ),
                  ),
                ),
              ],
            )),
      ):

      Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 20.0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
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
                                  authenticationController.logout();
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
                child: const Icon(
                  Icons.logout,
                  color: Colors.red,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child:
        Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Get.find<StudentController>()
                                        .pickedImage!
                                        .value !=
                                    null
                                ? Image.file(
                                    File(Get.find<StudentController>()
                                        .pickedImage!
                                        .value!
                                        .path),
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  )
                                : authenticationController
                                        .currentStudent.value!.avator!
                                        .trim()
                                        .isNotEmpty
                                    ? Image.network(
                                        authenticationController
                                            .currentStudent.value!.avator!,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/images/profile.png",
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                          Positioned(
                              bottom: 5,
                              right: -10,
                              child: InkWell(
                                onTap: () {
                                  imageDialog(page: 'student', upload: true);
                                },
                                child: const CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.amber,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    )),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                name: "Name",
                                textSize: 14.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "RedHatMedium",
                                textColor: Colors.grey,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonText(
                                    name: authenticationController
                                        .currentStudent
                                        .value!
                                        .fullName!
                                        .capitalize!,
                                    textSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "RedHatMedium",
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showCustomDialog(
                                          key: "name",
                                          context: context,
                                          tetx: authenticationController
                                              .currentStudent
                                              .value!
                                              .fullName!
                                              .capitalize!);
                                    },
                                    child: const Icon(Icons.edit),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                name: "Phone",
                                textSize: 14.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "RedHatMedium",
                                textColor: Colors.grey,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonText(
                                    name: authenticationController
                                        .currentStudent.value!.phone!,
                                    textSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "RedHatMedium",
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showCustomDialog(
                                          key: "phone",
                                          context: context,
                                          tetx: authenticationController
                                              .currentStudent.value!.phone!);
                                    },
                                    child: const Icon(Icons.edit),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              name: "Email",
                              textSize: 14.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "RedHatMedium",
                              textColor: Colors.grey,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CommonText(
                              name: authenticationController
                                  .currentStudent.value!.email!,
                              textSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "RedHatMedium",
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      return authenticationController
                                  .currentStudent.value!.driver ==
                              null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => DriverList());
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_circle_outline_outlined,
                                        size: 45,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CommonText(
                                        name: "Attach Driver",
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "RedHatMedium",
                                        textColor: Colors.amber,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: CommonText(
                                    name: "Driver info",
                                    textSize: 20.0,
                                    fontFamily: "RedHatMedium",
                                  ),
                                ),
                                Container(
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
                                              name: authenticationController
                                                  .currentStudent
                                                  .value!
                                                  .driver!
                                                  .fullname!
                                                  .capitalize!,
                                              fontFamily: "RedHatMedium",
                                            ),
                                            CommonText(
                                              name: authenticationController
                                                  .currentStudent
                                                  .value!
                                                  .driver!
                                                  .phoneNumber!,
                                              fontWeight: FontWeight.bold,
                                              textSize: 12,
                                            ),
                                            CommonText(
                                              name: authenticationController
                                                  .currentStudent
                                                  .value!
                                                  .driver!
                                                  .email!,
                                            ),
                                            SizedBox(height: 5,),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Icon(Icons.location_on),
                                                Expanded(
                                                  child: CommonText(
                                                      name:
                                                      authenticationController
                                                          .currentStudent
                                                          .value!
                                                          .driver!
                                                          .locationName!),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            );
                    })
                  ],
                ),
              ),
      ),
    ));
  }

  Widget editIcon() {
    return InkWell(
        onTap: () {
          Get.to(() => EditPage(),
              duration: const Duration(milliseconds: 3000),
              transition: Transition.cupertino);
        },
        child: const Icon(Icons.edit));
  }

  showCustomDialog(
      {required String key,
      required BuildContext context,
      required String tetx}) {
    showBottomSheet(
        context: context,
        // isScrollControlled: true,
        elevation: 100,
        clipBehavior: Clip.antiAlias,
        backgroundColor: Colors.white,
        builder: (_) {
          TextEditingController textEditingController = TextEditingController();
          textEditingController.text = tetx;
          return Container(
            height: kTextTabBarHeight * 5,
            width: double.infinity,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CommonText(
                    name: "Enter your ${key}",
                    fontWeight: FontWeight.bold,
                    fontFamily: "RedHatMedium",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: textEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: CommonText(
                            name: "Cancel",
                            fontFamily: "RedHatMedium",
                            fontWeight: FontWeight.bold,
                            textColor: Colors.red,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            Get.back();
                            if (textEditingController.text.trim().isNotEmpty) {
                              Get.find<StudentController>().editUser(
                                  id: authenticationController
                                      .currentStudent.value!.id!,
                                  body: {
                                    key == "name" ? "fullName" : "phoneNumber":
                                        textEditingController.text
                                  });
                            }
                          },
                          child: CommonText(
                            name: "Save",
                            fontFamily: "RedHatMedium",
                            fontWeight: FontWeight.bold,
                            textColor: Colors.amber,
                          ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

// SizedBox(
// width: 200.0,
// height: 100.0,
// child: Shimmer.fromColors(
// baseColor: Colors.red,
// highlightColor: Colors.yellow,
// child: Text(
// 'Shimmer',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontSize: 40.0,
// fontWeight:
// FontWeight.bold,
// ),
// ),
// ),
// );
