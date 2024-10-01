import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Street', style: TextStyle(color: Colors.grey.shade500)),
                TextFormField(
                  controller: _streetController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter street address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter street address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text('City', style: TextStyle(color: Colors.grey.shade500)),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter city',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text('State', style: TextStyle(color: Colors.grey.shade500)),
                TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter state',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter state';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text('ZIP Code', style: TextStyle(color: Colors.grey.shade500)),
                TextFormField(
                  controller: _zipController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter ZIP code',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ZIP code';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 170,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
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
                              SnackBar(
                                  content: Text('Failed to add address: $e')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User not logged in')),
                          );
                        }
                      }
                    },
                    child: Text('Save Address'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
