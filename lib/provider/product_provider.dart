import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:hackathon_project/model/review_model.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];
  int _selectedIndex = 0;

  List<Product> get products => _products;
  int get selectedIndex => _selectedIndex;

  Future<void> fetchProductsByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      final List<Product> loadedProducts = [];
      for (var doc in snapshot.docs) {
        loadedProducts.add(Product.fromFirestore(doc));
      }

      _products.clear();
      _products.addAll(loadedProducts);

      notifyListeners();
    } catch (e) {
      print('Failed to fetch products: $e');
      throw e;
    }
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
