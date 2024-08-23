import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hackathon_project/screen/order_detail.dart';
import 'package:hackathon_project/screen/popular_product.dart';
import 'package:hackathon_project/utils/const_text.dart';
import 'package:provider/provider.dart';
import 'package:hackathon_project/provider/product_provider.dart';
import 'package:hackathon_project/components/product_card.dart';
import 'package:hackathon_project/screen/product_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true; // Flag for loading state

  final categories = [
    'Electronics',
    'Shoes',
    'Men Fashion',
    'Women Fashion',
    'Jewelry',
    'Beauty',
  ];

  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchAllProducts(); // Fetch all products
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onCategoryTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final filteredProducts = productProvider.products.where((product) {
      return product.category == categories[_selectedIndex];
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        leading: const SizedBox(),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderDetail()));
              },
              icon: FaIcon(FontAwesomeIcons.basketShopping))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TopBanner(),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Categories',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => _onCategoryTap(index),
                      child: Container(
                        height: 40,
                        width: categories[index].length > 5 ? 120 : 80,
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? Colors.purple
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: _selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Products',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllProducts()),
                      );
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetail(product: product),
                              ),
                            );
                          },
                          child: ProductCard(product: product),
                        ),
                      );
                    },
                    childCount: filteredProducts.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.60,
                  ),
                ),
        ],
      ),
    );
  }
}

class TopBanner extends StatelessWidget {
  const TopBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          width: 400,
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                BoldWhiteText(text: 'Nike Air Max 270', size: 25),
                ConstText(
                  text: "Men's Shoes",
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  textOverflow: null,
                  maxLine: null,
                ),
                SizedBox(height: 20),
                BoldWhiteText(text: '\$290.00', size: 25),
              ],
            ),
          ),
        ),
        Positioned(
          right: -60,
          bottom: -95,
          child: Image.asset('images/banner1.png', height: 350),
        )
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.barTitle,
    required this.leadicon,
    required this.trailicon,
  });
  final String barTitle;
  final Widget leadicon;
  final Widget trailicon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leadicon,
          Text(
            barTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          trailicon,
        ],
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
