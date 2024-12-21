import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:schoolsto/models/student_model.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

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
                          margin: const EdgeInsets.all(4),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    name: studentModel.fullName!.capitalize!,
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
                              )),
                              InkWell(
                                onTap: ()async {
                                  final Uri phoneUri=Uri(scheme: 'tel', path: "${studentModel.phone}");

                                  if(await canLaunchUrl(phoneUri)){
                                    await launchUrl(phoneUri);
                                  }else{
                                     throw "Could not launch";
                                  }

                                },
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.green,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: drivercontroller.students.length,
                      shrinkWrap: true,
                    )
                  : Center(
                      child: CommonText(
                        name:
                            "You currently don't have any students assigned to you",
                        textSize: 16,
                        fontFamily: "RedHatMedium",
                      ),
                    );
        }),
      ),
    );
  }
}
