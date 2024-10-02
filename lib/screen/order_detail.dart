import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackathon_project/screen/orderTrack/order_track.dart';

class OrderDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final allOrders = snapshot.data!.docs;

          // Filter orders where the user's email exists in the 'items' array
          final userOrders = allOrders.where((orderDoc) {
            final orderData = orderDoc.data() as Map<String, dynamic>;
            final items = orderData['items'] as List<dynamic>;
            return items.any((item) => item['email'] == currentUser!.email);
          }).toList();

          if (userOrders.isEmpty) {
            return Center(child: Text('No orders found.'));
          }

          return ListView.builder(
            itemCount: userOrders.length,
            itemBuilder: (context, index) {
              final order = userOrders[index].data() as Map<String, dynamic>;
              final items = order['items'] as List<dynamic>;

              // Find the items belonging to the current user
              final userItems = items.where((item) {
                return item['email'] == currentUser!.email;
              }).toList();

              return GestureDetector(
                onTap: () {
                  // Navigate to OrderTracking with the selected order data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderTracking(orderData: order),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(order['receipt'] ?? 'Order Receipt'),
                          trailing: Text('Total: \$${order['totalPrice']}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 8.0), // Add some space between the title and items
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: userItems.map((item) {
                            return Text(
                                'Item: ${item['title']} (Qty: ${item['quantity']})');
                          }).toList(),
                        ),
                        SizedBox(height: 8.0), // Add some space before the status
                        Text(
                          'Status: ${order['status'] ?? 'N/A'}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
