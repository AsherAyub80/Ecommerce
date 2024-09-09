import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/provider/provider.dart';
import 'package:hackathon_project/screen/checkoutProcess/payment_screen.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class OrderSummaryScreen extends StatelessWidget {
  final String selectedAddressId;

  OrderSummaryScreen({required this.selectedAddressId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    final total = provider.totalPrice();
    final cartItems = provider.cart;

    return FutureBuilder<DocumentSnapshot>(
      future: _getUserDocument(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>?;
        if (userData == null || userData['Address'] == null) {
          return Center(child: Text('User data not found.'));
        }

        final addressList = userData['Address'] as List<dynamic>;
        final addressData = addressList.isNotEmpty
            ? addressList[int.tryParse(selectedAddressId) ?? 0]
                as Map<String, dynamic>?
            : null;

        if (addressData == null) {
          return Center(child: Text('Address not found.'));
        }

        final address =
            '${addressData['street']}, ${addressData['city']}, ${addressData['state']} ${addressData['zip']}';

        return Scaffold(
          appBar: AppBar(title: Text('Order Summary')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address:'),
                SizedBox(height: 8),
                Text(address),
                SizedBox(height: 16),
                Text('Order Summary'),
                SizedBox(height: 8),
                ...cartItems.map((item) => ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.quantity.toString()),
                      trailing: Text('\$${item.price.toString()}'),
                    )),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:'),
                    Text('\$${total.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentScreen(address: address)),
                );
              },
              child: Text('Proceed to Payment'),
            ),
          ),
        );
      },
    );
  }

  Future<DocumentSnapshot> _getUserDocument() async {
    final authService = AuthService();
    final currentUser = authService.getCurrentUser();
    if (currentUser != null) {
      final uid = currentUser.uid;
      return FirebaseFirestore.instance.collection('users').doc(uid).get();
    } else {
      throw Exception('User not logged in');
    }
  }
}
