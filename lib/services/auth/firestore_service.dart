import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_project/model/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addOrder(List<ProductModel> cart, double totalPrice) async {
    final now = DateTime.now();
    final timestamp = Timestamp.fromDate(now);

    // Convert products to a map
    final orderDetails = cart.map((product) {
      return {
        'title': product.title,
        'quantity': product.quantity,
        'price': product.price,
      };
    }).toList();

    final receipt = orderDetails.map((item) {
      return '${item['quantity']} x ${item['title']}- \$${item['price']}';
    }).join('\n');

    final orderData = {
      'date': timestamp,
      'receipt': receipt,
      'totalPrice': totalPrice,
      'items': orderDetails,
      
    };

    await _db.collection('orders').add(orderData);
  }
}