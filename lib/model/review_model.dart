import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String userId;
  final String userName;
  final String comment;
  final double rating;
  final DateTime date;

  Review({
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.date,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    final dateField = map['date'];
    DateTime date;
    if (dateField is Timestamp) {
      date = dateField.toDate();
    } else if (dateField is String) {
      date = DateTime.parse(dateField);
    } else {
      throw Exception('Invalid date format');
    }

    return Review(
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      comment: map['comment'] as String,
      rating: (map['rating'] as num).toDouble(),
      date: date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'rating': rating,
      'date': Timestamp.fromDate(date),
    };
  }
}