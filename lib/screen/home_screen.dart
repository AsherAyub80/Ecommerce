import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/components/category.dart';
import 'package:hackathon_project/model/product_model.dart';

import 'package:hackathon_project/services/auth/auth_service.dart';
import 'package:hackathon_project/utils/const_text.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = AuthService();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot> getUserData() async {
    final currentUser = authService.getCurrentUser();
    if (currentUser != null) {
      final email = currentUser.email;
      if (email != null) {
        QuerySnapshot querySnapshot =
            await users.where('email', isEqualTo: email).get();
        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first;
        } else {
          throw Exception('No user data found');
        }
      } else {
        throw Exception('User email is null');
      }
    } else {
      throw Exception('No user is currently logged in');
    }
  }

  List<List<ProductModel>> selectcategories = [
    all,
    shoes,
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu),
                    Text(
                      'Home',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.search)
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 200,
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        BoldWhiteText(
                          text: 'Nike Air Max 270',
                          size: 25,
                        ),
                        ConstText(
                            text: "Men's Shoes",
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        SizedBox(
                          height: 20,
                        ),
                        BoldWhiteText(text: '\$290.00', size: 25),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Image.asset(
                  'images/banner1.png',
                  height: 40,
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text('See All'),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(category.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        child: Center(
                          child: Text(
                            category[index].cateTitle,
                            style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        height: 40,
                        width: category[index].cateTitle.length > 5 ? 100 : 80,
                        decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? Colors.purple
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Product',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text('See All'),
                ],
              ),
            ),
            Expanded(child: ListView.builder(itemBuilder: (context, index) {
              return Container(
                child: Column(),
              );
            }))
          ],
        ),
      ),
    );
  }
}

class BoldWhiteText extends StatelessWidget {
  const BoldWhiteText({
    super.key,
    required this.text,
    required this.size,
  });
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: size),
    );
  }
}
