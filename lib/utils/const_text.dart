import 'package:flutter/material.dart';

class ConstText extends StatelessWidget {
  const ConstText(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.fontWeight});
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: fontSize,
          fontWeight: fontWeight),
    );
  }
}


