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
    String paymentMethod,
    Map<String, dynamic> storeLocation, // Add storeLocation parameter
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
      'paymentMethod': paymentMethod,
      'storeLocation': storeLocation, // Store location
    };

    try {
      await _db.collection('orders').add(orderData);
    } catch (e) {
      print('Failed to add order: $e');
      throw Exception('Failed to add order');
    }
  }

  Future<Map<String, dynamic>> getStoreDetails(String storeId) async {
    try {
      DocumentSnapshot storeDoc =
          await _db.collection('stores').doc(storeId).get();
      if (storeDoc.exists) {
        final data = storeDoc.data() as Map<String, dynamic>;
        return {
          'lat': data['location']['lat'],
          'lng': data['location']['lang'],
         
        };
      } else {
        throw Exception('Store not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch store details: $e');
    }
  }
}
