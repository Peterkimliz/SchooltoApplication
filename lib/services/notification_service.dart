import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:schoolsto/widgets/common_text.dart';

import '../utils/constants/constants.dart';

class NotificationService {
  static void sendChatNotification({
    required String email,
    required String message,
  }) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(oneSignalApiUrl),
        headers: {
          "Authorization": "Basic $oneSignalApiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "target_channel": "push",
          "include_aliases": {
            "external_id": [email]
          },
          "headings": {"en": "Listing"},
          "contents": {"en": message},
          "ios_interruption_level": "critical",
          "app_id": oneSignalKey,
          "large_icon":
              "https://firebasestorage.googleapis.com/v0/b/first-app-d5d01.appspot.com/o/downloa.jpeg?alt=media&token=a2063bae-575e-4bd8-ae88-53e1a9bc61d2",
          "data": {"message": message}
        }),
      );
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: CommonText(name: "response is ${response.body}"),
        backgroundColor: Colors.green,
      ));

      if (response.statusCode == 200) {
        print("Notification sent successfully");

      }
    } catch (error) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: CommonText(name: "Error sending notification: $error"),
        backgroundColor: Colors.red,
      ));
      print("Error sending notification: $error");
    }
  }
}
