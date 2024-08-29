import 'package:flutter/material.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:hackathon_project/provider/favourite_provider.dart';
import 'package:hackathon_project/provider/provider.dart';
import 'package:hackathon_project/screen/product_detail.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favouriteProvider = Provider.of<FavouriteProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        width: 200,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 160,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: product.imageUrl.isNotEmpty
                            ? Hero(
                                tag: product.imageUrl,
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.scaleDown,
                                ),
                              )
                            : const Center(
                                child: Text('No Image'),
                              ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 4,
                      child: FavouriteIconButton(
                          favouriteProvider: favouriteProvider,
                          product: product),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.orange, size: 20),
                          Text(
                            product.averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final productInCart = cartProvider.isProductInCart(product.id);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: productInCart ? Colors.deepPurple : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: productInCart ? 140 : 50,
                  height: 50,
                  child: productInCart
                      ? buildCartContent(context, cartProvider)
                      : buildAddButton(context, cartProvider),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddButton(BuildContext context, CartProvider cartProvider) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.deepPurple),
        onPressed: () {
          cartProvider.addToCart(product);
        },
      ),
    );
  }

  Widget buildCartContent(
    BuildContext context,
    CartProvider cartProvider,
  ) {
    final productIndex =
        cartProvider.cart.indexWhere((p) => p.id == product.id);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: IconButton(
            icon: const Icon(Icons.remove, color: Colors.white),
            onPressed: () {
              if (productIndex != -1) {
                cartProvider.decrementQty(productIndex);
              }
            },
          ),
        ),
        SizedBox(
          width: 50,
          height: 50,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.bounceIn,
            switchOutCurve: Curves.bounceOut,
            child: Text(
              '${productIndex != -1 ? cartProvider.getQuantity(product.id) : 0}',
              key: ValueKey<int>(productIndex != -1
                  ? cartProvider.getQuantity(product.id)
                  : 0),
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              if (productIndex != -1) {
                cartProvider.incrementQty(productIndex);
              }
            },
          ),
        ),
      ],
    );
  }
}

class FavouriteIconButton extends StatefulWidget {
  const FavouriteIconButton({
    super.key,
    required this.favouriteProvider,
    required this.product,
  });

  final FavouriteProvider favouriteProvider;
  final Product product;

  @override
  State<FavouriteIconButton> createState() => _FavouriteIconButtonState();
}

class _FavouriteIconButtonState extends State<FavouriteIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.favouriteProvider.toggleFavourite(widget.product);

        _controller.forward().then((_) {
          _controller.reverse();
        });
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          widget.favouriteProvider.isExist(widget.product)
              ? Icons.favorite
              : Icons.favorite_outline,
          color: widget.favouriteProvider.isExist(widget.product)
              ? Colors.red
              : Colors.black,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
