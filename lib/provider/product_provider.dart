import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:hackathon_project/model/review_model.dart';
import 'package:hackathon_project/services/auth/firestore_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  int _selectedIndex = 0;

  List<Product> get products => _products;
  int get selectedIndex => _selectedIndex;

  // Fetch all products
  Future<void> fetchAllProducts() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
    _products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    notifyListeners();
  }

  // Fetch store details by storeId
  Future<Map<String, dynamic>> fetchStoreDetails(String storeId) async {
    final firestoreService = FirestoreService();
    return await firestoreService.getStoreDetails(storeId);
  }

  // Listen to changes on a specific product
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

  // Add a review to a product and update Firestore
  Future<void> addReviewToProduct(String productId, Review review) async {
    final productIndex = _products.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      final product = _products[productIndex];

      // Add the review to the product's reviews list
      final updatedReviews = List<Review>.from(product.reviews)..add(review);

      // Calculate the new average rating
      final newRating = updatedReviews.fold(0.0, (sum, review) => sum + review.rating) /
          updatedReviews.length;

      // Update the product with the new review and rating
      _products[productIndex] = Product(
        id: product.id,
        title: product.title,
        description: product.description,
        price: product.price,
        store: product.store,
        category: product.category,
        imageUrl: product.imageUrl,
        colors: product.colors,
        rating: newRating,
        quantity: product.quantity,
        reviews: updatedReviews,
        storeId: product.storeId, // Ensure the storeId is preserved
      );

      // Update the product document in Firestore
      final productRef = FirebaseFirestore.instance.collection('products').doc(productId);
      await productRef.update({
        'reviews': updatedReviews.map((r) => r.toMap()).toList(),
        'rating': newRating,
      });

      notifyListeners();
    }
  }
}
