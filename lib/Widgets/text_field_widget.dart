import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.label,
    this.icon,
    required this.controller,
    this.obsecure = true,
  });
  final String label;
  final icon;
  final TextEditingController controller;
  final bool obsecure;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
      child: TextField(
        obscureText: obsecure,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(17),
          fillColor: Color(0xffF7F8F9),
          filled: true,
          hintText: label,
          suffixIcon: Padding(
            padding: EdgeInsets.all(15),
            child: icon,
          ),
          hintStyle: TextStyle(color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
