import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Address')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Street'),
            TextField(controller: _streetController),
            SizedBox(height: 16),
            Text('City'),
            TextField(controller: _cityController),
            SizedBox(height: 16),
            Text('State'),
            TextField(controller: _stateController),
            SizedBox(height: 16),
            Text('ZIP Code'),
            TextField(controller: _zipController),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                final authService = AuthService();
                final currentUser = authService.getCurrentUser();
                if (currentUser != null) {
                  final userId = currentUser.uid;
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .update({
                      'Address': FieldValue.arrayUnion([
                        {
                          'street': _streetController.text,
                          'city': _cityController.text,
                          'state': _stateController.text,
                          'zip': _zipController.text,
                        }
                      ])
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add address: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User not logged in')),
                  );
                }
              },
              child: Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }
}
