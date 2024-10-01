import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_project/screen/checkoutProcess/add_adress_screen.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';
import 'package:hackathon_project/screen/checkoutProcess/order_summary_screen.dart';
import 'package:hackathon_project/stepperWidget/stepper.dart';

class AddressSelectionScreen extends StatefulWidget {
  @override
  _AddressSelectionScreenState createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedAddressId;
  late CollectionReference users;

  @override
  void initState() {
    super.initState();
    users = _firestore.collection('users');
  }

  Stream<Map<String, dynamic>?> _loadUserDetails() async* {
    try {
      final authService = AuthService();
      final currentUser = authService.getCurrentUser();
      if (currentUser != null) {
        final uid = currentUser.uid;
        yield* users.doc(uid).snapshots().map((docSnapshot) {
          if (docSnapshot.exists) {
            return docSnapshot.data() as Map<String, dynamic>?;
          } else {
            throw Exception('No user data found');
          }
        });
      } else {
        throw Exception('No user is currently logged in');
      }
    } catch (e) {
      yield null; // Handle errors gracefully
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    final authService = AuthService();
    final currentUser = authService.getCurrentUser();
    if (currentUser != null) {
      final uid = currentUser.uid;
      try {
        final DocumentReference userDoc = users.doc(uid);
        final DocumentSnapshot userSnapshot = await userDoc.get();

        if (userSnapshot.exists) {
          final List<dynamic> addresses = userSnapshot['Address'] ?? [];
          addresses
              .removeAt(int.parse(addressId)); // Remove the address by index
          await userDoc.update({'Address': addresses}); // Update Firestore
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete address: $e')),
        );
      }
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
      body: Column(
        children: [
           Container(
            color: Colors.grey[200],
            child: StepperHeader(
              stepIcons: [
                Icons.shopping_cart,
                Icons.location_city,
                Icons.summarize,
                Icons.payment,
              ],
              currentStep: 1,
              steps: ['Cart', 'Address', 'Summary', 'Payment'],
            ),
          ),
          Expanded(
            child: StreamBuilder<Map<String, dynamic>?>(
              stream: _loadUserDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Failed to load user details: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!['Address'] == null ||
                    (snapshot.data!['Address'] as List).isEmpty) {
                  return Center(
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
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 14.0, horizontal: 10),
                            ),
                            child: Text('Add Address'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  var addresses = snapshot.data!['Address'] as List;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            var address = addresses[index];
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
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Confirm Deletion'),
                                          content: Text(
                                              'Are you sure you want to delete this address?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _deleteAddress(index
                                                    .toString()); // Call delete method
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
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
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.0),
                          ),
                          child: Text('Add Address'),
                        ),
                      ),
                    ],
                  );
                }
              },
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
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14.0),
          ),
          child: Text('Proceed to Summary'),
        ),
      ),
    );
  }
}
