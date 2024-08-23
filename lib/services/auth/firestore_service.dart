import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_project/model/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addOrder(List<Product> cart, double totalPrice, String username, String email) async {
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
        'status':'Pending',

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
    };

    try {
      await _db.collection('orders').add(orderData);
    } catch (e) {
      // Handle any errors that occur during the Firestore write operation
      print('Failed to add order: $e');
      throw Exception('Failed to add order');
    }
  }
}
