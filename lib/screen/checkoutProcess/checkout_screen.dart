import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_project/screen/checkoutProcess/add_adress_screen.dart';
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
      appBar: AppBar(
        title: Text(
          'Select Address',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: userDetails == null
          ? Center(child: CircularProgressIndicator())
          : userDetails!['Address'] == null ||
                  (userDetails!['Address'] as List).isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_off, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No addresses available.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddAddressScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple, // Button color
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                          ),
                          child: Text('Add Address'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: (userDetails!['Address'] as List).length,
                        itemBuilder: (context, index) {
                          var address =
                              (userDetails!['Address'] as List)[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 4,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              title: Text(
                                '${address['street']}, ${address['city']}, ${address['state']} ${address['zip']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
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
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddAddressScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(150, 60),
                          backgroundColor: Colors.deepPurple, // Button color
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                        ),
                        child: Text('Add Address'),
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, // Button color
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14.0),
          ),
          child: Text('Proceed to Summary'),
        ),
      ),
    );
  }
}
