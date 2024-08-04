import 'package:flutter/material.dart';
import 'package:hackathon_project/Widgets/bottom_nav.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:hackathon_project/provider/favourite_provider.dart';
import 'package:hackathon_project/screen/product_detail.dart';
import 'package:provider/provider.dart';

class PopularProduct extends StatelessWidget {
  PopularProduct({
    super.key,
  });

  List<List<ProductModel>> selectcategories = [
    all,
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
                    MaterialPageRoute(builder: (context) => BottomNav()));
              },
              child: Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Text(
            'Popular Product',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // number of items in each row
            mainAxisSpacing: 8.0, // spacing between rows
            crossAxisSpacing: 8.0, // spacing between columns
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
                      child: Image.asset(
                        selectcategories[0][index].image,
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                                Text(selectcategories[0][index].review),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                                "\$${selectcategories[select][index].price.toString()}",
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
          },
        ));
  }
}
