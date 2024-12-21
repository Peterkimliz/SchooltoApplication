import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/student_controller.dart';
import 'package:get/get.dart';

class StudentHome extends StatelessWidget {
  StudentHome({super.key});

  final StudentController studentController = Get.find<StudentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() =>
            studentController.pages[studentController.currentIndex.value]),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
              currentIndex: studentController.currentIndex.value,
              onTap: (value) {
                studentController.currentIndex.value = value;
              },
              selectedItemColor: Colors.amber,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Profile")
              ]),
        ));
  }
}
