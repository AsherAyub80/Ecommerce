import 'package:flutter/material.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hackathon_project/model/review_model.dart';
import 'package:hackathon_project/provider/favourite_provider.dart';
import 'package:hackathon_project/provider/product_provider.dart';
import 'package:hackathon_project/provider/provider.dart';
import 'package:hackathon_project/screen/add_review.dart';
import 'package:hackathon_project/screen/cart_screen.dart';
import 'package:hackathon_project/screen/home_screen.dart';
import 'package:hackathon_project/screen/more_reviews_screen.dart';
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
  bool seeMore = false;

  @override
  void initState() {
    super.initState();
    // Start listening for product changes
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.listenToProductChanges(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.products
        .firstWhere((prod) => prod.id == widget.product.id);
    final favProvider = Provider.of<FavouriteProvider>(context);
    final cart = Provider.of<CartProvider>(context);
    final DateFormat formatter = DateFormat('yyyy-MMM-dd');

    // Sort reviews by date (newest first)
    final sortedReviews = product.reviews.reversed.toList();

    // Show only the newest 3 reviews
    final List<Review> reviewsToShow = sortedReviews.take(3).toList();

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
                    favProvider.toggleFavourite(product);
                  },
                  icon: Icon(
                    favProvider.isExist(product)
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
            Hero(
              tag: product.imageUrl,
              child: Container(
                height: 200,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
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
                        product.title,
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
                            textOverflow: null,
                            maxLine: null,
                          ),
                          const SizedBox(width: 5),
                          ConstText(
                            text: product.seller,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            textOverflow: null,
                            maxLine: null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: product.rating,
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
                    ],
                  ),
                  Text(
                    "\$${product.price.toString()}",
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
                    maxLine: null,
                    text: 'Color',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    textOverflow: null,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: List.generate(
                      product.colors.length,
                      (index) {
                        final colorHex = product.colors[index];
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
                        textOverflow: TextOverflow.visible,
                        maxLine: 1,
                        text: 'About',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedCrossFade(
                            duration: Duration(milliseconds: 300),
                            firstChild: ConstText(
                              text: product.description,
                              maxLine: 2,
                              textOverflow: TextOverflow.ellipsis,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                            secondChild: ConstText(
                              text: product.description,
                              maxLine: null,
                              textOverflow: null,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                            crossFadeState: seeMore
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                          ),
                          SizedBox(height: 4),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                seeMore = !seeMore;
                              });
                            },
                            child: Text(seeMore ? 'See Less' : 'See More'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reviews:',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReview(
                                    productId: product.id,
                                  ),
                                ),
                              );
                            },
                            child: Text('Add review'),
                          ),
                        ],
                      ),
                      reviewsToShow.isEmpty
                          ? Center(child: Text('No reviews'))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: reviewsToShow.length,
                              itemBuilder: (context, index) {
                                final review = reviewsToShow[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(review.userName[0]),
                                  ),
                                  title: Text(review.userName),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                      if (product.reviews.length > 3)
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MoreReviewsScreen(reviews: sortedReviews),
                                ),
                              );
                            },
                            child: Text('See All Reviews'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: MyButton(
                  text: 'Add To Cart',
                  onTap: () {
                    cart.addToCart(product);
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
        width: MediaQuery.of(context).size.width - 200,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
