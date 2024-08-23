import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    title: Text(order['receipt']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: userItems.map((item) {
                        return Text(
                            'Item: ${item['title']}\nStatus: ${item['status']}');
                      }).toList(),
                    ),
                    trailing: Text('Total: \$${order['totalPrice']}'),
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
