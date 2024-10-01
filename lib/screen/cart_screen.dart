import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hackathon_project/Widgets/bottom_nav.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:hackathon_project/provider/provider.dart';
import 'package:hackathon_project/screen/checkoutProcess/checkout_screen.dart';
import 'package:hackathon_project/screen/home_screen.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';
import 'package:hackathon_project/stepperWidget/stepper.dart';
import 'package:hackathon_project/utils/const_text.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference users;

  @override
  void initState() {
    super.initState();
    users = _firestore
        .collection('users'); // Initialize the 'users' collection reference
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      final authservice = AuthService();
      final currentUser = authservice.getCurrentUser();
      if (currentUser != null) {
        final email = currentUser.email;
        if (email != null) {
          final QuerySnapshot querySnapshot =
              await users.where('email', isEqualTo: email).get();
          if (querySnapshot.docs.isNotEmpty) {
            setState(() {
              userDetails =
                  querySnapshot.docs.first.data() as Map<String, dynamic>;
              isLoading = false;
            });
          } else {
            throw Exception('No user data found');
          }
        } else {
          throw Exception('User email is null');
        }
      } else {
        throw Exception('No user is currently logged in');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);

    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.deepPurple,
      //   onPressed: showModelBottomSheet,
      //   child: Icon(
      //     Icons.payment,
      //     color: Colors.white,
      //   ),
      // ),

      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          SafeArea(
            child: CustomAppBar(
              barTitle: 'Cart',
              trailicon: const Icon(Icons.shopping_cart_outlined),
              leadicon: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNav()),
                  );
                },
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
          StepperHeader(
            stepIcons: [
              Icons.shopping_cart,
              Icons.location_city,
              Icons.summarize,
              Icons.payment,
            ],
            currentStep: 0,
            steps: ['Cart', 'Address', 'Payment', 'Confirmation'],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.cart.length,
              itemBuilder: (context, index) {
                final cartItem = provider.cart[index];
                return Dismissible(
                  key: Key(cartItem.toString()),
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFE6E5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        const Icon(FontAwesomeIcons.trashCan,
                            color: Color(0xffDB818C)),
                      ],
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    provider.deleteAt(index);
                  },
                  child: CartCard(
                    cartItem: cartItem,
                    provider: provider,
                    index: index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CheckoutCard(
        totalPrice: provider.totalPrice(),
        onCheckout: () async {
          if (provider.cart.isEmpty) {
            showCustomTopSnackBar(context,'Cart is Empty');
          } else
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddressSelectionScreen()));
        },
      ),
    );
  }

  void showCustomTopSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 50, 
          left: 16,
          right: 16,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration:BoxDecoration(color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16.0),
              
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

class CartCard extends StatelessWidget {
  const CartCard({
    super.key,
    required this.cartItem,
    required this.provider,
    required this.index,
  });

  final Product cartItem;
  final CartProvider provider;
  final int index;

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 100,
                child: Image.network(
                  cartItem.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    cartItem.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      ConstText(
                        text: cartItem.category,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        textOverflow: null,
                        maxLine: null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "\$${cartItem.price.toString()}",
                    style: const TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AddSub(
                    color: Colors.grey.shade300,
                    icon: const Icon(Icons.remove),
                    onTap: () {
                      provider.decrementQty(index);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      cartItem.quantity.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  AddSub(
                    color: Colors.deepPurple,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onTap: () {
                      provider.incrementQty(index);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddSub extends StatelessWidget {
  const AddSub({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
  });
  final Widget icon;
  final Function()? onTap;
  final color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: color,
        ),
        child: icon,
      ),
    );
  }
}

// class MySeparator extends StatelessWidget {
//   const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
//       : super(key: key);
//   final double height;
//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         final boxWidth = constraints.constrainWidth();
//         const dashWidth = 10.0;
//         final dashHeight = height;
//         final dashCount = (boxWidth / (2 * dashWidth)).floor();
//         return Flex(
//           children: List.generate(dashCount, (_) {
//             return SizedBox(
//               width: dashWidth,
//               height: dashHeight,
//               child: DecoratedBox(
//                 decoration: BoxDecoration(color: color),
//               ),
//             );
//           }),
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           direction: Axis.horizontal,
//         );
//       },
//     );
//   }
// }

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    Key? key,
    required this.totalPrice,
    required this.onCheckout,
  }) : super(key: key);

  final double totalPrice;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.receipt),
                ),
                const Spacer(),
                const Text("Add voucher code"),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "Total:\n",
                      children: [
                        TextSpan(
                          text: "\$${totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCheckout,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    child: const Text("Check Out"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
