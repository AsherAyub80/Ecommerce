// ignore_for_file: use_build_context_synchronously

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/model/product_model.dart' as pm;
import 'package:hackathon_project/screen/reciept_screen.dart';
import 'package:hackathon_project/services/auth/firestore_service.dart';

class CartProvider extends ChangeNotifier {
  final List<pm.ProductModel> _cart = [];
  List<pm.ProductModel> get cart => _cart;

  void addToCart(pm.ProductModel product) {
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
    for (pm.ProductModel element in _cart) {
      total += element.price * element.quantity;
    }

    return total;
  }

  Future<void> checkout(BuildContext ctx) async {
    BotToast.showLoading();
    final firestoreService = FirestoreService();
    final total = totalPrice();
    final List<pm.ProductModel> myCart =
        List.from(cart); // Create a copy of the cart
    // Store the order in Firestore
    await firestoreService.addOrder(cart, total);
    debugPrint("Cart Length ${cart.length}");
    _cart.clear();
    BotToast.closeAllLoading();
    BotToast.showText(text: "Order Placed!", contentColor: Colors.green);
    notifyListeners();
    Navigator.pushReplacement(ctx, MaterialPageRoute(
      builder: (context) {
        return RecieptScreen(listCart: myCart);
      },
    ));
  }
}
