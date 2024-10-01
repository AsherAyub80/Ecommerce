import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hackathon_project/provider/page_view_provider.dart';
import 'package:hackathon_project/screen/order_detail.dart';
import 'package:hackathon_project/screen/popular_product.dart';
import 'package:hackathon_project/services/auth/auth_service.dart';
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
  Map<String, dynamic>? userDetails;
  final AuthService authService = AuthService();
  bool isLoading = true; // Consolidated loading state

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference users;

  int _selectedIndex = 0;

  final List<String> categories = [
    'Electronics',
    'Shoes',
    'Men Fashion',
    'Women Fashion',
    'Jewelry',
    'Beauty',
  ];

  @override
  void initState() {
    super.initState();
    users = _firestore.collection('users');
    _fetchProducts();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      final currentUser = authService.getCurrentUser();
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

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchAllProducts();
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        isLoading = false;
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
    final currentUserDetails = userDetails;
    final username = currentUserDetails?['username'] ?? 'User';

    final filteredProducts = productProvider.products.where((product) {
      return product.category == categories[_selectedIndex];
    }).toList();

    // Fixed item size
    const itemSize = 150.0;

    // Calculate the number of items per row
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / itemSize).floor();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstText(
                            text: 'Welcome back!',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            textOverflow: null,
                            maxLine: null),
                        Text(
                          username[0].toUpperCase() + username.substring(1),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          child: FaIcon(FontAwesomeIcons.magnifyingGlass,
                              size: 20),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetail(),
                                ),
                              );
                            },
                            icon: Icon(Icons.shopping_cart_outlined),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
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
                        width: categories.length > 5 ? 120 : 80,
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? Colors.deepPurple
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
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
                  const Text(
                    'Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
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
          isLoading
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio:
                        itemSize / (itemSize * 1.5), // Maintain aspect ratio
                  ),
                ),
        ],
      ),
    );
  }
}

class TopBanner extends StatefulWidget {
  const TopBanner({super.key});

  @override
  _TopBannerState createState() => _TopBannerState();
}

class _TopBannerState extends State<TopBanner> {
  final PageController _pageController = PageController();
  Timer? _timer;
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
  }

  void _startAutoSwipe() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && imageUrls.isNotEmpty) {
        int currentPage = _pageController.page!.round();
        int nextPage = currentPage + 1;

        if (nextPage >= imageUrls.length) {
          nextPage = 0;
        }

        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );

        // Update the page index in the provider
        Provider.of<PageIndexProvider>(context, listen: false)
            .updatePage(nextPage);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('promotions').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No promotions available.'));
        }

        imageUrls =
            snapshot.data!.docs.map((doc) => doc['image'] as String).toList();

        if (_timer == null && imageUrls.isNotEmpty) {
          _startAutoSwipe();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(imageUrls[index], fit: BoxFit.cover),
                    );
                  },
                  onPageChanged: (index) {
                    // Update the current page in the provider when the user swipes
                    Provider.of<PageIndexProvider>(context, listen: false)
                        .updatePage(index);
                  },
                ),
              ),
            ),
            Consumer<PageIndexProvider>(
              builder: (context, pageIndexProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(imageUrls.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      width:
                          pageIndexProvider.currentPage == index ? 18.0 : 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: pageIndexProvider.currentPage == index
                            ? Colors.deepPurple
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        );
      },
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
