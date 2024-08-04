import 'package:flutter/material.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:hackathon_project/provider/favourite_provider.dart';
import 'package:hackathon_project/screen/product_detail.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.productModel,
  });
  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouriteProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                      product: productModel,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        width: 200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      provider.toggleFavourite(productModel);
                    },
                    icon: Icon(provider.isExist(productModel)
                        ? Icons.favorite
                        : Icons.favorite_outline),
                    color: Colors.red),
              ],
            ),
            Container(
              height: 140,
              width: 160,
              child: Image.asset(
                productModel.image,
                fit: BoxFit.fill,
              ),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12)),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productModel.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 20),
                        Text(productModel.review),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text("\$${productModel.price.toString()}",
                        style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
