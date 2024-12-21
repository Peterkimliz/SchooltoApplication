import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schoolsto/widgets/common_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class DbBase {
  static const getRequest = "GET";
  static const postRequest = "POST";
  static const putRequest = "PUT";
  static const deleteRequest = "DELETE";

  static databaseRequest(String url, String method,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    try {
        SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
        String? token=sharedPreferences.getString("token");
        headers??={
          "Content-Type":"application/json",
          // if(token!=null)
          // "Authorization":"Bearer $token",
          "Accept":"application/json"
        };
      var request = http.Request(method, Uri.parse(url));
      if (body != null) {
        request.body = json.encode(body);
      }
      request.headers.addAll(headers);
      print("url is $url");
      print("method is $method");

      http.StreamedResponse response = await request.send();
      return response.stream.bytesToString();
    } catch (e) {
      print("The error is $e");
    }
  }
}
