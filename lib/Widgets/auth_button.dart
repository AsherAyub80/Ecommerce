import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.text, this.onTap,
  });
  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          width: MediaQuery.of(context).size.width - 50,
          decoration: BoxDecoration(
              color: Color(0xff1E232C), borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
