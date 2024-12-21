import 'package:get/get.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:schoolsto/controllers/student_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
         Get.put<AuthenticationController>(AuthenticationController(),permanent: true);
         Get.put<Drivercontroller>(Drivercontroller(),permanent: true);
          Get.put<StudentController>(StudentController(),permanent: true);
  }
}
