import 'package:flutter/material.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:hackathon_project/services/auth/firestore_service.dart';

class CartProvider extends ChangeNotifier {
  final List<ProductModel> _cart = [];
  List<ProductModel> get cart => _cart;

  void addToCart(ProductModel product) {
    if (_cart.contains(product)) {
      for (var element in _cart) {
        element.quantity++;
      }
    } else {
      product.quantity = 1;
      _cart.add(product);
    }
    notifyListeners();
  }

  void increamentQty(int index) {
    _cart[index].quantity++;
    notifyListeners();
  }

  void decreamentQty(int index) {
    if (_cart[index].quantity > 0) {
      _cart[index].quantity--;
      if (_cart[index].quantity < 1) {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void deleteAt(int index) {
    _cart.removeAt(index);
    notifyListeners();
  }

  totalPrice() {
    double total = 0.0;
    for (ProductModel element in _cart) {
      total += element.price * element.quantity;
    }

    return total;
  }

  Future<void> checkout() async {
    final firestoreService = FirestoreService();
    final total = totalPrice();

    // Store the order in Firestore
    await firestoreService.addOrder(cart, total);

    _cart.clear();
    notifyListeners();
  }
}
