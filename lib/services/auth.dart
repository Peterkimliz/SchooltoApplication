import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schoolsto/services/client.dart';
import 'package:schoolsto/services/end_point.dart';
import 'package:get/get.dart';

class Auth {

static loginUser(Map<String,dynamic>body)async{
  var response=await DbBase.databaseRequest(signIn, DbBase.postRequest,body: body);
  return json.decode(response);

}

static signnInUser(Map<String,dynamic>body)async{
  var response=await DbBase.databaseRequest(signUp, DbBase.postRequest,body: body);
  return json.decode(response);

}


}