import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hackathon_project/model/review_model.dart';
import 'package:hackathon_project/provider/product_provider.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class AddReview extends StatefulWidget {
  final String productId;

  AddReview({Key? key, required this.productId}) : super(key: key);

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final TextEditingController reviewController = TextEditingController();
  double userRating = 3.0;
  String userName = 'Anonymous';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final authService = AuthService();
    try {
      final userDetails = await authService.loadCurrentUserDetails();
      setState(() {
        userName = userDetails?['username'] ?? 'Anonymous';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUser = authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            userRating = rating;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        maxLines: 3,
                        maxLength: 120,
                        controller: reviewController,
                        decoration: InputDecoration(
                          hintText: 'Write a review',
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            final review = Review(
                              userId: currentUser?.uid ?? 'unknown',
                              userName: userName,
                              comment: reviewController.text,
                              rating: userRating,
                              date: DateTime.now(),
                            );

                            Provider.of<ProductProvider>(context, listen: false)
                                .addReviewToProduct(widget.productId, review);
                            reviewController.clear();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
