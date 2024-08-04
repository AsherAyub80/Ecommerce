import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/Widgets/bottom_nav.dart';
import 'package:hackathon_project/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //user login
            if (snapshot.hasData) {
              return BottomNav();
            } else {
              return const LoginOrRegister();
            }
          }),
    );
  }
}
