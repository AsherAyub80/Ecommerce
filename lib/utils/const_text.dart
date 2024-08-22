import 'package:flutter/material.dart';

class ConstText extends StatelessWidget {
  const ConstText(
      {super.key,
      required this.text,
      required this.fontSize,
      this.color,
      required this.fontWeight,
      required this.textOverflow,required this.maxLine});
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final  textOverflow;
  final  maxLine;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: textOverflow,
      maxLines: maxLine,
      style: TextStyle(
          color: color ?? Colors.grey.shade400,
          fontSize: fontSize,
          fontWeight: fontWeight,),
    );
  }
}
