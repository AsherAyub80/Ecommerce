import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';
import 'package:hackathon_project/screen/checkoutProcess/order_summary_screen.dart';

class AddressSelectionScreen extends StatefulWidget {
  @override
  _AddressSelectionScreenState createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedAddressId;
  late CollectionReference users;
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    users = _firestore.collection('users');
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      final authService = AuthService();
      final currentUser = authService.getCurrentUser();
      if (currentUser != null) {
        final uid = currentUser.uid; // Get UID from current user
        final DocumentSnapshot docSnapshot =
            await users.doc(uid).get(); // Use UID to get the document
        if (docSnapshot.exists) {
          setState(() {
            userDetails = docSnapshot.data() as Map<String, dynamic>;
          });
        } else {
          throw Exception('No user data found');
        }
      } else {
        throw Exception('No user is currently logged in');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Address')),
      body: userDetails == null
          ? Center(child: CircularProgressIndicator())
          : userDetails!['Address'] == null ||
                  (userDetails!['Address'] as List).isEmpty
              ? Center(child: Text('No addresses available.'))
              : ListView.builder(
                  itemCount: (userDetails!['Address'] as List).length,
                  itemBuilder: (context, index) {
                    var address = (userDetails!['Address'] as List)[index];
                    return ListTile(
                      title: Text(
                          '${address['street']}, ${address['city']}, ${address['state']} ${address['zip']}'),
                      leading: Radio<String>(
                        value: index.toString(),
                        groupValue: selectedAddressId,
                        onChanged: (value) {
                          setState(() {
                            selectedAddressId = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          selectedAddressId = index.toString();
                        });
                      },
                    );
                  },
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            if (selectedAddressId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderSummaryScreen(
                    selectedAddressId: selectedAddressId!,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please select an address')),
              );
            }
          },
          child: Text('Proceed to Summary'),
        ),
      ),
    );
  }
}
