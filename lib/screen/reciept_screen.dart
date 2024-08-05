import 'package:flutter/material.dart';

import 'package:hackathon_project/model/product_model.dart';
import '../Widgets/bottom_nav.dart';
import '../utils/const_text.dart';
import 'product_detail.dart';

class RecieptScreen extends StatelessWidget {
  final List<ProductModel> listCart;
  const RecieptScreen({super.key, required this.listCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ConstText(
                  text: 'Thanks for your order',
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              Expanded(
                  child: ListView.builder(
                      itemCount: listCart.length,
                      itemBuilder: (context, index) {
                        final cartItem = listCart[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(cartItem.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          )),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.yellow),
                                          ConstText(
                                              text: cartItem.review,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text("\$${cartItem.price.toString()}",
                                          style: const TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          )),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    width: 100,
                                    child: Image.asset(
                                      cartItem.image,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                  text: 'Back to Home',
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const BottomNav();
                      },
                    ));
                  }),
            ],
          ),
        ),
      ),
    ));
  }
}
