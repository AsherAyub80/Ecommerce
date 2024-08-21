import 'package:flutter/material.dart';
import 'package:hackathon_project/Widgets/bottom_nav.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:hackathon_project/provider/favourite_provider.dart';
import 'package:hackathon_project/screen/product_detail.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PopularProduct extends StatelessWidget {
  PopularProduct({
    super.key,
  });

  List<List<Product>> selectcategories = [
    
  ];
  int select = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouriteProvider>(context);

    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const BottomNav()));
              },
              child: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: const Text(
            'Popular Product',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 0.70,
          ),
          itemCount: selectcategories[select].length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetail(
                              product: selectcategories[0][index],
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
                              provider.toggleFavourite(
                                  selectcategories[select][index]);
                            },
                            icon: Icon(provider
                                    .isExist(selectcategories[select][index])
                                ? Icons.favorite
                                : Icons.favorite_outline),
                            color: Colors.red),
                      ],
                    ),
                    Container(
                      height: 140,
                      width: 160,
                      child: Image.network(
                        selectcategories[0][index].imageUrl,
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
                              selectcategories[select][index].title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                                Text(selectcategories[0][index]
                                    .reviews
                                    .length
                                    .toString()),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                                "\$${selectcategories[select][index].price.toString()}",
                                style: const TextStyle(
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
          },
        ));
  }
}
