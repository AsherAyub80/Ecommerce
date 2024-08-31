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
    const HomeScreen(),
    const Favourite(),
    const CartScreen(),
    const ProfileScreen(),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(12)),
          height: 60,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
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
                            color: currentIndex == 0
                                ? Colors.white
                                : Colors.grey.shade400,
                          )),
                      AnimatedCont(
                        currentIndex: currentIndex,
                        myIndex: 0,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              currentIndex = 1;
                            });
                          },
                          icon: Icon(
                            Icons.favorite_border,
                            size: 30,
                            color: currentIndex == 1
                                ? Colors.white
                                : Colors.grey.shade400,
                          )),
                      AnimatedCont(
                        currentIndex: currentIndex,
                        myIndex: 1,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              currentIndex = 2;
                            });
                          },
                          icon: Icon(
                            Icons.shopping_bag_outlined,
                            size: 30,
                            color: currentIndex == 2
                                ? Colors.white
                                : Colors.grey.shade400,
                          )),
                      AnimatedCont(
                        currentIndex: currentIndex,
                        myIndex: 2,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              currentIndex = 3;
                            });
                          },
                          icon: Icon(
                            Icons.person_outline,
                            size: 30,
                            color: currentIndex == 3
                                ? Colors.white
                                : Colors.grey.shade400,
                          )),
                      AnimatedCont(
                        currentIndex: currentIndex,
                        myIndex: 3,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: screens[currentIndex],
    );
  }
}

class AnimatedCont extends StatelessWidget {
  const AnimatedCont({
    super.key,
    required this.currentIndex,
    this.myIndex,
  });

  final int currentIndex;
  final myIndex;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 10,
      width: 15,
      curve: Curves.bounceInOut,
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
          color: currentIndex == myIndex ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }
}
