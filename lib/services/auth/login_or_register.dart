import 'package:flutter/material.dart';
import 'package:hackathon_project/services/auth/sign_in_screen.dart';
import 'package:hackathon_project/services/auth/sign_up_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initialy show login page
  bool showloginpage = true;

  //toggle between login and register page
  void togglePages() {
    setState(() {
      showloginpage = !showloginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showloginpage) {
      return SignInScreen(
        onTap: togglePages,
      );
    } else {
      return SignUpScreen(
        onTap: togglePages,
      );
    }
  }
}