import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_project/model/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
Future<void> addOrder(
    List<Product> cart,
    double totalPrice,
    String username,
    String email,
    String storeId,
    String address,
    String paymentMethod, // New parameter
) async {
    final now = DateTime.now();
    final timestamp = Timestamp.fromDate(now);

    // Create the order details from the cart items
    final orderDetails = cart.map((product) {
        return {
            'username': username,
            'email': email,
            'title': product.title,
            'quantity': product.quantity,
            'price': product.price,
        };
    }).toList();

    // Format the receipt string
    final receipt = orderDetails.map((item) {
        return '${item['quantity']} x ${item['title']} - \$${item['price']}';
    }).join('\n');

    // Create the order data
    final orderData = {
        'date': timestamp,
        'receipt': receipt,
        'totalPrice': totalPrice,
        'items': orderDetails,
        'storeId': storeId,
        'address': address,
        'status': 'Pending',
        'paymentMethod': paymentMethod, // Store payment method with the order
    };

    try {
        await _db.collection('orders').add(orderData);
    } catch (e) {
        print('Failed to add order: $e');
        throw Exception('Failed to add order');
    }
}

}
