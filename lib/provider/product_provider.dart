import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:hackathon_project/model/review_model.dart';

class ProductProvider with ChangeNotifier {
   List<Product> _products = [];
  int _selectedIndex = 0;

  List<Product> get products => _products;
  int get selectedIndex => _selectedIndex;


  Future<void> fetchAllProducts() async {
    // For example:
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
    _products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    notifyListeners();
  }
  void listenToProductChanges(String productId) {
  FirebaseFirestore.instance.collection('products').doc(productId).snapshots().listen((snapshot) {
    final updatedProduct = Product.fromFirestore(snapshot);
    final productIndex = _products.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      _products[productIndex] = updatedProduct;
      notifyListeners();
    }
  });
}

    Future<void> addReviewToProduct(String productId, Review review) async {
    final productIndex = _products.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      final product = _products[productIndex];
      
      final updatedReviews = List<Review>.from(product.reviews)..add(review);

      final newRating = updatedReviews.fold(0.0, (sum, review) => sum + review.rating) / updatedReviews.length;

      _products[productIndex] = Product(
        id: product.id,
        title: product.title,
        description: product.description,
        price: product.price,
        seller: product.seller,
        category: product.category,
        imageUrl: product.imageUrl,
        colors: product.colors,
        rating: newRating,
        quantity: product.quantity,
        reviews: updatedReviews,
      );

      // Update Firestore
      final productRef = FirebaseFirestore.instance.collection('products').doc(productId);
      await productRef.update({
        'reviews': updatedReviews.map((r) => r.toMap()).toList(),
        'rating': newRating,
      });

      notifyListeners();
    }
  }
}
