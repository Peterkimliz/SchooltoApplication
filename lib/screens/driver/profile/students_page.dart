import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:schoolsto/models/student_model.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/custom_button.dart';

class StudentsPage extends StatelessWidget {
  StudentsPage({super.key});

  Drivercontroller drivercontroller = Get.find<Drivercontroller>();

  @override
  Widget build(BuildContext context) {
    drivercontroller.getStudents();
    return Scaffold(
      appBar: AppBar(
        title: CommonText(
            name: "Students",
            fontFamily: "RedHatMedium",
            fontWeight: FontWeight.bold),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          drivercontroller.getStudents();
        },
        child: Obx(() {
          return drivercontroller.loadingStudents.value
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.all(10),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.grey.withOpacity(0.4),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 200,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 10,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 30,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: 10,
                  shrinkWrap: true,
                )
              : drivercontroller.students.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        StudentModel studentModel =
                            drivercontroller.students.elementAt(index);
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0.3, 0.3),
                                    blurRadius: 0.1,
                                    spreadRadius: 0.1)
                              ]),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  studentModel.image != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            studentModel.image!,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                            studentModel.fullName!.capitalize!,
                                        fontFamily: "RedHatMedium",
                                        textSize: 18,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CommonText(
                                        name: studentModel.phone!,
                                        fontFamily: "RedHatMedium",
                                        textSize: 14,
                                      ),
                                    ],
                                  )),
                                  InkWell(
                                    onTap: () async {
                                      drivercontroller.subStatus.value =
                                          studentModel.subscribed == false
                                              ? 1
                                              : 0;
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (_) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              width: double.infinity,
                                              padding: EdgeInsets.only(
                                                  top: 20, right: 10, left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    name: "Subscription Status",
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "RedHatMedium",
                                                    textDecoration:
                                                        TextDecoration
                                                            .underline,
                                                  ),
                                                  Obx(
                                                    () => Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Expanded(
                                                          child: RadioListTile(
                                                            value: 0,
                                                            activeColor:
                                                                Colors.amber,
                                                            groupValue:
                                                                drivercontroller
                                                                    .subStatus
                                                                    .value,
                                                            onChanged: (val) {
                                                              drivercontroller
                                                                  .subStatus
                                                                  .value = val!;
                                                            },
                                                            title: Text(
                                                                "Subscribed"),
                                                            dense: true,
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: RadioListTile(
                                                            value: 1,
                                                            activeColor:
                                                                Colors.amber,
                                                            groupValue:
                                                                drivercontroller
                                                                    .subStatus
                                                                    .value,
                                                            onChanged: (val) {
                                                              drivercontroller
                                                                  .subStatus
                                                                  .value = val!;
                                                            },
                                                            title: const Text(
                                                                "Not Subscribed"),
                                                            dense: true,
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  CustomButton(
                                                    title: 'Save Changes',
                                                    onTap: () {
                                                      Get.back();
                                                      drivercontroller
                                                          .updateStudentStatus(
                                                              id: studentModel
                                                                  .id);
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Icon(
                                      Icons.more_vert,
                                      color: Colors.green,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(Icons.location_on),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: CommonText(
                                      name: studentModel.locationName!,
                                      fontFamily: "RedHatMedium",
                                      textSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: drivercontroller.students.length,
                      shrinkWrap: true,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: CommonText(
                          name:
                              "You currently don't have\n any students assigned to you",
                          textSize: 20,
                          fontFamily: "RedHatMedium",
                        ),
                      ),
                    );
        }),
      ),
    );
  }
}
