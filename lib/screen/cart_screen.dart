import 'package:flutter/material.dart';
import 'package:hackathon_project/Widgets/bottom_nav.dart';
import 'package:hackathon_project/provider/provider.dart';
import 'package:hackathon_project/screen/home_screen.dart';
import 'package:hackathon_project/screen/product_detail.dart';
import 'package:hackathon_project/screen/reciept_screen.dart';
import 'package:hackathon_project/utils/const_text.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          SafeArea(
            child: CustomAppBar(
              barTitle: 'Cart ',
              trailicon: const Icon(Icons.shopping_cart_outlined),
              leadicon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNav()));
                  },
                  child: const Icon(Icons.arrow_back_ios)),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: provider.cart.length,
                  itemBuilder: (context, index) {
                    final cartItem = provider.cart[index];
                    return Dismissible(
                      key: Key(cartItem.toString()),
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        provider.deleteAt(index);
                      },
                      child: Padding(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 15),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      AddSub(
                                          icon: const Icon(Icons.add),
                                          onTap: () {
                                            provider.increamentQty(index);
                                          }),
                                      Text(cartItem.quantity.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          )),
                                      AddSub(
                                          icon: const Icon(Icons.remove),
                                          onTap: () {
                                            provider.decreamentQty(index);
                                          }),
                                    ],
                                  ),
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
                      ),
                    );
                  })),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ConstText(
                          text: 'select item:',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      Text(provider.cart.length.toString(),
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ConstText(
                          text: 'Sub total:',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      Text('\$${provider.totalPrice().toString()}',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstText(
                          text: 'Discount (%0):',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      Text('\$0',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ConstText(
                          text: 'Total:',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      Text('\$${provider.totalPrice().toString()}',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MyButton(
              text: 'CheckOut',
              onTap: () {
                provider.checkout(context);
              }),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class AddSub extends StatelessWidget {
  const AddSub({
    super.key,
    required this.icon,
    this.onTap,
  });
  final Widget icon;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
        child: icon,
      ),
    );
  }
}
