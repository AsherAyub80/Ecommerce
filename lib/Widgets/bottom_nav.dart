import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hackathon_project/screen/home_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

List screens = [
  HomeScreen(),
  Scaffold(),
  Scaffold(),
  Scaffold(),
  Scaffold(),
];
int currentIndex = 0;

class _BottomNavState extends State<BottomNav> {
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
                  color: currentIndex == 0
                      ? Color(0xff4157FF)
                      : Colors.grey.shade400,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
                icon: FaIcon(
                  FontAwesomeIcons.bell,
                  size: 30,
                  color: currentIndex == 1
                      ? Color(0xff4157FF)
                      : Colors.grey.shade400,
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
                  color: currentIndex == 2
                      ? Color(0xff4157FF)
                      : Colors.grey.shade400,
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
                  color: currentIndex == 3
                      ? Color(0xff4157FF)
                      : Colors.grey.shade400,
                )),
          ],
        ),
      ),
      body: screens[currentIndex],
    );
  }
}
