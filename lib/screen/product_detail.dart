import 'package:flutter/material.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:hackathon_project/screen/home_screen.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            SafeArea(
              child: CustomAppBar(
                barTitle: 'Product detail',
                trailicon: Icon(Icons.favorite_outline_outlined),
                leadicon: Icon(Icons.arrow_back_ios),
              ),
            ),
            Container(
              height: 200,
              child: Center(
                child: Image.asset(product.image),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ));
  }
}
