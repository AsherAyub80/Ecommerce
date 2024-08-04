import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hackathon_project/Widgets/bottom_nav.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:hackathon_project/provider/favourite_provider.dart';
import 'package:hackathon_project/provider/provider.dart';
import 'package:hackathon_project/screen/cart_screen.dart';
import 'package:hackathon_project/screen/home_screen.dart';
import 'package:hackathon_project/utils/const_text.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int currentColor = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    final fav = Provider.of<FavouriteProvider>(context);

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: CustomAppBar(
                  barTitle: 'Product detail',
                  trailicon: IconButton(
                      onPressed: () {
                        fav.toggleFavourite(widget.product);
                      },
                      icon: Icon(fav.isExist(widget.product)
                          ? Icons.favorite
                          : Icons.favorite_outline),
                      color: Colors.red),
                  leadicon: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNav()));
                      },
                      child: Icon(Icons.arrow_back_ios)),
                ),
              ),
              Container(
                height: 200,
                child: Center(
                  child: Image.asset(widget.product.image),
                ),
                decoration: BoxDecoration(
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
                        Text(widget.product.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ConstText(
                                text: 'Seller:',
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                            SizedBox(height: 5),
                            ConstText(
                                text: widget.product.seller,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(5, (index) {
                              return Icon(Icons.star, color: Colors.orange);
                            })),
                      ],
                    ),
                    Text("\$${widget.product.price.toString()}",
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstText(
                        text: 'Color',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    SizedBox(height: 20),
                    Row(
                      children: List.generate(
                          widget.product.colors.length,
                          (index) => GestureDetector(
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
                                    color: currentColor == index
                                        ? Colors.white
                                        : widget.product.colors[index],
                                    border: currentColor == index
                                        ? Border.all(
                                            color: widget.product.colors[index])
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
                                        color: widget.product.colors[index],
                                        shape: BoxShape.circle),
                                  ),
                                ),
                              )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('About',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 10,
                    ),
                    ConstText(
                        text: widget.product.description,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: MyButton(
                    text: 'Add To Cart',
                    onTap: () {
                      provider.addToCart(widget.product);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen()));
                    }),
              ),
              SizedBox(height: 15),
            ],
          ),
        ));
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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )),
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
