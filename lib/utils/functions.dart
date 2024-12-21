import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:schoolsto/controllers/student_controller.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';






showDefaultGetDialog({required String message}
    ){

  return Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false, // Prevent dialog from closing on outside tap
  );
}
imageDialog({required String page,  bool upload=false,}) {
  final Drivercontroller drivercontroller = Get.find<Drivercontroller>();
  final StudentController studentController = Get.find<StudentController>();
  showDialog(
      context: Get.context!,
      builder: (_) {
        return AlertDialog(
          title: Center(
              child: CommonText(
            name: "Select Image",
            fontWeight: FontWeight.bold,
            fontFamily: "RedHatMedium",
            textSize: 20.0,
          )),
          content: SizedBox(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                    onTap: () {
                      if (page == "driver") {
                        drivercontroller.pickImage(value: 0,upload:upload);
                      }else{
                        studentController.pickImage(value: 0,upload:upload);
                      }
                    },
                    leading: const Icon(Icons.camera_alt),
                    title: CommonText(
                      name: "Camera",
                      fontFamily: "RedHatMedium",
                    )),
                ListTile(
                    onTap: () {
                      if (page == "driver") {
                        drivercontroller.pickImage(value: 1,upload: upload);
                      }
                      else{
                        studentController.pickImage(value: 1,upload: upload);
                      }
                    },
                    leading: const Icon(Icons.photo),
                    title: CommonText(
                      name: "Gallery",
                      fontFamily: "RedHatMedium",
                    ))
              ],
            ),
          ),
        );
      });
}

saveCreatedAccount()async{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  sharedPreferences.setBool("accountCreated", true);
}
