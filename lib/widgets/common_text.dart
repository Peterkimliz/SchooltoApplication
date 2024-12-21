import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CommonText extends StatelessWidget {
  final String name;
  Color textColor;
  final double textSize;
  final FontWeight fontWeight;
  final String fontFamily;
  final TextDecoration textDecoration;
  CommonText(
      {super.key,
      required this.name,
      this.textColor = const Color(0XFF0000000),
      this.textSize = 14.0,
      this.fontWeight = FontWeight.normal,
      this.fontFamily = "RedHatLight",
      this.textDecoration = TextDecoration.none});

  @override
  Widget build(BuildContext context) {
    return Text(name,
        softWrap: true,

        style: TextStyle(
            decoration: textDecoration,
            decorationColor: textColor,
            // decorationStyle: TextDecorationStyle(),
            decorationThickness: 1.0,
            color: textColor,
            fontFamily: fontFamily,
            fontSize: textSize,
            fontWeight: fontWeight),
    );
  }
}
