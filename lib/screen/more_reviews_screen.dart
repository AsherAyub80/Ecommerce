import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hackathon_project/model/review_model.dart';
import 'package:intl/intl.dart';

class MoreReviewsScreen extends StatefulWidget {
  final List<Review> reviews; // Adjust this to fit your review model

  const MoreReviewsScreen({Key? key, required this.reviews}) : super(key: key);

  @override
  State<MoreReviewsScreen> createState() => _MoreReviewsScreenState();
}

class _MoreReviewsScreenState extends State<MoreReviewsScreen> {
  bool startAnimation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MMM-dd');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('User Feedbacks and reviews'),
      ),
      body: widget.reviews.isEmpty
          ? Center(child: Text('No reviews'))
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: widget.reviews.length,
              itemBuilder: (context, index) {
                final review = widget.reviews[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Reviews(review, formatter, index),
                );
              },
            ),
    );
  }

  Widget Reviews(Review review, DateFormat formatter, int index) {
    final width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      width: width,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 700 + (index * 100)),
      transform: Matrix4.translationValues(startAnimation ? 0 : width, 0, 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Text(review.userName[0]),
          ),
          title: Text(review.userName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingBarIndicator(
                rating: review.rating,
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
              Text(review.comment),
            ],
          ),
          trailing: Text(
            '${formatter.format(review.date.toLocal())}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
