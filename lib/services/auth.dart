import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schoolsto/services/client.dart';
import 'package:schoolsto/services/end_point.dart';
import 'package:get/get.dart';

class Auth {
  static loginUser(Map<String, dynamic> body) async {
    var response =
        await DbBase.databaseRequest(signIn, DbBase.postRequest, body: body);
    return json.decode(response);
  }

  static signnInUser(Map<String, dynamic> body) async {
    var response =
        await DbBase.databaseRequest(signUp, DbBase.postRequest, body: body);
    print("Mimi iam bold $response");
    return json.decode(response);
  }

  static resendOtp({required String email}) async {
    var response = await DbBase.databaseRequest(
        "$resend?email=${email.trim()}", DbBase.postRequest);
    return json.decode(response);
  }

  static resetUserPassword({required Map<String, String> body}) async {
    var response = await DbBase.databaseRequest(
        resetPassword, DbBase.putRequest,
        body: body);
    return json.decode(response);
  }

  static verifyOtp(String verificationCode) async {
    var response = await DbBase.databaseRequest(
      "$verification?otp=$verificationCode",
      DbBase.postRequest,
    );
    return json.decode(response);
  }
}
