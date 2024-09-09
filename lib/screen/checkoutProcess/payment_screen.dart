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
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selected Address'),
            SizedBox(height: 8),
            Text(widget.address),
            SizedBox(height: 16),
            username != null
                ? Text('Hello, $username!')
                : Center(child: CircularProgressIndicator()),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                final user = await AuthService().getCurrentUser();
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
                        context, username!, email, storeId, widget.address);
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
            ),
          ],
        ),
      ),
    );
  }
}
