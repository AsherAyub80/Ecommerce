import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_project/model/review_model.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String seller;
  final String category;
  final String imageUrl;
  final List<String> colors;
  final double rating;
  int quantity;
  final List<Review> reviews; // Added reviews field

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.seller,
    required this.category,
    required this.imageUrl,
    required this.colors,
    required this.rating,
    this.quantity = 0,
    required this.reviews, // Initialize reviews
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Parse reviews from Firestore data
    List<Review> parsedReviews = (data['reviews'] as List<dynamic>?)
        ?.map((reviewData) => Review.fromMap(reviewData as Map<String, dynamic>))
        .toList() ?? [];

    return Product(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      seller: data['seller'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['image'] ?? '',
      colors: List<String>.from(data['colors'] ?? []),
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      quantity: data['quantity'] ?? 0,
      reviews: parsedReviews,
    );
    
  }  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    double totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Product) return false;
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
