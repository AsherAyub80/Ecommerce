import 'package:flutter/material.dart';
import 'package:hackathon_project/Widgets/bottom_nav.dart';
import 'package:hackathon_project/model/category_list.dart';
import 'package:hackathon_project/screen/home_screen.dart';

class CategorySceen extends StatefulWidget {
  const CategorySceen({super.key});

  @override
  State<CategorySceen> createState() => _CategorySceenState();
}

int selectIndex = 0;

class _CategorySceenState extends State<CategorySceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: CustomAppBar(
                  barTitle: 'Category',
                  trailicon: Icon(Icons.search),
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
              TopBanner(),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categoryList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // number of items in each row
                  mainAxisSpacing: 10.0, // spacing between rows
                  crossAxisSpacing: 10.0, // spacing between columns
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: selectIndex == index
                              ? Colors.purple
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: selectIndex == index
                                  ? Colors.purpleAccent
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: categoryList[index],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            categtext[index],
                            style: TextStyle(
                                color: selectIndex == index
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }
}
