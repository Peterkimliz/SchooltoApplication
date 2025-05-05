// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:schoolsto/bindings.dart';
import 'package:schoolsto/controllers/AuthenticationController.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:get/get.dart';
import 'package:schoolsto/controllers/student_controller.dart';
import 'package:schoolsto/utils/constants/constants.dart';

import 'screens/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  oneSignal();
  runApp(MyApp());
}

Future<void> oneSignal() async {
  initOneSignal();
  oneSignalObservers();
}

void initOneSignal() {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(oneSignalKey);
  OneSignal.Notifications.requestPermission(false);
}

oneSignalObservers() {
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    event.notification.display();
  });
  OneSignal.Notifications.addClickListener((event) {});
}

class MyApp extends StatelessWidget {
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final Drivercontroller drivercontroller = Get.put(Drivercontroller());
  final StudentController studentController = Get.put(StudentController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SchoolTo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          primaryColor: Colors.amber,
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          cardColor: Colors.white,
          bottomNavigationBarTheme:
              BottomNavigationBarThemeData(backgroundColor: Colors.white),
          cardTheme: const CardTheme(
              color: Colors.white, shadowColor: Colors.grey, elevation: 5.0)),
      home: const SplashScreen(),
      initialBinding: AppBindings(),
    );
  }
}
