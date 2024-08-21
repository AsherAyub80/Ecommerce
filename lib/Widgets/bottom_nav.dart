import 'package:flutter/material.dart';
import 'package:hackathon_project/screen/cart_screen.dart';
import 'package:hackathon_project/screen/favourite.dart';
import 'package:hackathon_project/screen/home_screen.dart';
import 'package:hackathon_project/screen/profile.dart';


final GlobalKey<_BottomNavState> bottomNavKey = GlobalKey<_BottomNavState>();

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});


  @override
  State<BottomNav> createState() => _BottomNavState();
}



class _BottomNavState extends State<BottomNav> {
  final List screens = [
  HomeScreen(),
  const Favourite(),
  const CartScreen(),
  ProdileScreen(),
  
];
int currentIndex = 0;
  void resetToFirstTab() {
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
                icon: Icon(
                  Icons.home_outlined,
                  size: 30,
                  color:
                      currentIndex == 0 ? Colors.purple : Colors.grey.shade400,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.favorite_outline,
                  size: 30,
                  color:
                      currentIndex == 1 ? Colors.purple : Colors.grey.shade400,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  size: 30,
                  color:
                      currentIndex == 2 ? Colors.purple : Colors.grey.shade400,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 3;
                  });
                },
                icon: Icon(
                  Icons.person_outline,
                  size: 30,
                  color:
                      currentIndex == 3 ? Colors.purple : Colors.grey.shade400,
                )),
          ],
        ),
      ),
      body: screens[currentIndex],
    );
  }
}
