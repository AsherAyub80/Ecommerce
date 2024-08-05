import 'package:flutter/material.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';

class ProdileScreen extends StatelessWidget {
  ProdileScreen({super.key});
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          authService.signOut();
        },
        child: const Text(
          'sign Out',
          style: TextStyle(color: Colors.black),
        ),
      )),
    );
  }
}
