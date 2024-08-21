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
        onPressed: () async {
          try {
            await authService.signOut();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Signed out successfully')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign out failed: $e')),
            );
          }
        },
        child: const Text(
          'signout',
          style: TextStyle(color: Colors.black),
        ),
      )),
    );
  }
}
