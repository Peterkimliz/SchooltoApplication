import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

InputDecoration inputDecoration(
    {required hint,
    required label,
    IconData? suffixIcon,
    VoidCallback? callBack}) {
  return InputDecoration(
    hintText: hint,
    labelText: label,
    suffixIcon:suffixIcon==null?null: InkWell(
        onTap: () {
          callBack!();
        },
        child: Icon(suffixIcon)),
    hintStyle:
        const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
    labelStyle: const TextStyle(color: Colors.black),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54, width: 1)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54, width: 1)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54, width: 1)),
  );
}

InputDecoration inputDecorationMoney(
    {required hint,
    required label,
    IconData? suffixIcon,
    VoidCallback? callBack}) {
  return InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
    hintText: hint,
    labelText: label,
    hintStyle:
        const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
    labelStyle: const TextStyle(color: Colors.black),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54, width: 1)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54, width: 1)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54, width: 1)),
  );
}
