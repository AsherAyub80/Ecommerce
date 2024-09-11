import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_project/provider/provider.dart';
import 'package:hackathon_project/screen/checkoutProcess/confrimation_screen.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final String address;

  PaymentScreen({required this.address});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? userDetails;
  final AuthService authService = AuthService();
  bool isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference users;
  String _selectedPaymentMethod = 'COD'; // Default payment method

  @override
  void initState() {
    users = _firestore.collection('users');
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final currentUser = authService.getCurrentUser();
      if (currentUser != null) {
        final email = currentUser.email;
        if (email != null) {
          final QuerySnapshot querySnapshot =
              await users.where('email', isEqualTo: email).get();
          if (querySnapshot.docs.isNotEmpty) {
            setState(() {
              userDetails =
                  querySnapshot.docs.first.data() as Map<String, dynamic>;
              isLoading = false;
            });
          } else {
            throw Exception('No user data found');
          }
        } else {
          throw Exception('User email is null');
        }
      } else {
        throw Exception('No user is currently logged in');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    final total = provider.totalPrice();
    final cartItems = provider.cart;
    final currentUserDetails = userDetails;
    final username = currentUserDetails?['username'] ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Consistent with the theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(widget.address),
            SizedBox(height: 16),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Text(
                    'Hello, $username!',
                    style: TextStyle(fontSize: 16),
                  ),
            SizedBox(height: 16),
            Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            RadioListTile<String>(
              title: Text('Cash on Delivery (COD)'),
              value: 'COD',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('Credit/Debit Card'),
              value: 'CARD',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final user = await authService.getCurrentUser();
                  if (user != null) {
                    final email = user.email!;
                    final storeId = provider.cart.isNotEmpty
                        ? provider.cart.first.storeId
                        : null;
                    if (storeId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Unable to determine store.')),
                      );
                      return;
                    }
                    try {
                      await provider.checkout(
                        context,
                        username,
                        email,
                        storeId,
                        widget.address,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConfirmationScreen()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Checkout failed: $e')),
                      );
                    }
                  }
                },
                child: Text('Confirm Order'),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(160, 60),
                  backgroundColor: Colors.deepPurple, // Button color
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
