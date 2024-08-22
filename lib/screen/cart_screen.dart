import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/Widgets/bottom_nav.dart';
import 'package:hackathon_project/provider/provider.dart';
import 'package:hackathon_project/screen/home_screen.dart';
import 'package:hackathon_project/screen/product_detail.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';
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
                                    const Icon(Icons.star,
                                        color: Colors.yellow),
                                    ConstText(
                                      text: cartItem.reviews.length.toString(),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold, textOverflow: null, maxLine: null,
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
                                      provider.incrementQty(index);
                                    },
                                  ),
                                  Text(
                                    cartItem.quantity.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  AddSub(
                                    icon: const Icon(Icons.remove),
                                    onTap: () {
                                      provider.decrementQty(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ConstText(
                        text: 'Selected items:',
                        fontSize: 18,
                        fontWeight: FontWeight.bold, textOverflow: null, maxLine: null,
                      ),
                      Text(
                        provider.cart.length.toString(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        fontWeight: FontWeight.bold, textOverflow: null, maxLine: null,
                      ),
                      Text(
                        '\$${provider.totalPrice().toString()}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        fontWeight: FontWeight.bold, textOverflow: null, maxLine: null,
                      ),
                      Text(
                        '\$0',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        fontWeight: FontWeight.bold, textOverflow: null, maxLine: null,
                      ),
                      Text(
                        '\$${provider.totalPrice().toString()}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
            onTap: () async {
              if (userDetails == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Unable to fetch user details.')),
                );
                return;
              }

              final email = userDetails!['email'] as String;
              final username = userDetails!['username'] as String;

              try {
                await provider.checkout(context, username, email);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Checkout failed: $e')),
                );
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
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
