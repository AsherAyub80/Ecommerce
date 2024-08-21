import 'package:flutter/material.dart';
import 'package:hackathon_project/model/product_model.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hackathon_project/model/review_model.dart';
import 'package:hackathon_project/provider/favourite_provider.dart';
import 'package:hackathon_project/provider/product_provider.dart';
import 'package:hackathon_project/provider/provider.dart';
import 'package:hackathon_project/screen/cart_screen.dart';
import 'package:hackathon_project/screen/home_screen.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';
import 'package:hackathon_project/utils/const_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int currentColor = 0;
 

  void _showReviewDialog(BuildContext context) async {
    final TextEditingController reviewController = TextEditingController();
    double userRating = 3.0;

    final authService = AuthService();
    final currentUser = authService.getCurrentUser();
    final userDetails = await authService.loadCurrentUserDetails();
    final userName = userDetails?['username'] ?? 'Anonymous';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
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
                  userRating = rating;
                },
              ),
              TextField(
                controller: reviewController,
                decoration: InputDecoration(hintText: 'Write a review'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
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
                    .addReviewToProduct(widget.product.id, review);
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavouriteProvider>(context);
    final cart = Provider.of<CartProvider>(context);
    final DateFormat formatter = DateFormat('yyyy-MMM-dd');

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: CustomAppBar(
                barTitle: 'Product Detail',
                trailicon: IconButton(
                  onPressed: () {
                    favProvider.toggleFavourite(widget.product);
                  },
                  icon: Icon(
                    favProvider.isExist(widget.product)
                        ? Icons.favorite
                        : Icons.favorite_outline,
                  ),
                  color: Colors.red,
                ),
                leadicon: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
            Container(
              height: 200,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const ConstText(
                            text: 'Seller:',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(width: 5),
                          ConstText(
                            text: widget.product.seller,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                 RatingBarIndicator(
                        rating: widget.product.averageRating,
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    
                  
                    ],
                  ),
                  Text(
                    "\$${widget.product.price.toString()}",
                    style: const TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ConstText(
                    text: 'Color',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: List.generate(
                      widget.product.colors.length,
                      (index) {
                        final colorHex = widget.product.colors[index];
                        final color = Color(
                            int.parse(colorHex.replaceFirst('#', '0xff')));

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentColor = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  currentColor == index ? Colors.white : color,
                              border: currentColor == index
                                  ? Border.all(color: color)
                                  : null,
                            ),
                            padding: currentColor == index
                                ? const EdgeInsets.all(2)
                                : null,
                            margin: const EdgeInsets.only(right: 15),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ConstText(
                        text: 'About',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      ConstText(
                        text: widget.product.description,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reviews:',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            onPressed: () => _showReviewDialog(context),
                            child: Text('Add Review'),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.product.reviews.length,
                        itemBuilder: (context, index) {
                          final review = widget.product.reviews[index];
                          return ListTile(
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const SizedBox(height: 15),
            Center(
              child: MyButton(
                  text: 'Add To Cart',
                  onTap: () {
                    cart.addToCart(widget.product);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartScreen()));
                  }),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });
  final String text;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        height: 60,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
