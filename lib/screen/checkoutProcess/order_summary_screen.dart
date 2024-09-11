import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/provider/provider.dart';
import 'package:hackathon_project/screen/checkoutProcess/payment_screen.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class OrderSummaryScreen extends StatelessWidget {
  final String selectedAddressId;

  OrderSummaryScreen({
    required this.selectedAddressId,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    final total = provider.totalPrice();
    final cartItems = provider.cart;

    return FutureBuilder<DocumentSnapshot>(
      future: _getUserDocument(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Order Summary',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Order Summary')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Order Summary',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Center(child: Text('User data not found.')),
          );
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>?;
        if (userData == null || userData['Address'] == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Order Summary')),
            body: Center(child: Text('User data not found.')),
          );
        }

        final addressList = userData['Address'] as List<dynamic>;
        final addressData = addressList.isNotEmpty
            ? addressList[int.tryParse(selectedAddressId) ?? 0]
                as Map<String, dynamic>?
            : null;

        if (addressData == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Order Summary',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Center(child: Text('Address not found.')),
          );
        }

        final address =
            '${addressData['street']}, ${addressData['city']}, ${addressData['state']} ${addressData['zip']}';

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Order Summary',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      address,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      var item = cartItems[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        title: Text(
                          item.title,
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          'Quantity: ${item.quantity.toString()}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                            address: address))); // Proceed to the next step
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.0),
              ),
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
