import 'package:flutter/material.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:provider/provider.dart';

class FavouriteProvider extends ChangeNotifier {
  final List<Product> _favourite = [];

  List<Product> get favourites => _favourite;

  void toggleFavourite(Product product) {
    if (_favourite.contains(product)) {
      _favourite.removeWhere((p) => p.id == product.id);
    } else {
      _favourite.add(product);
    }
    notifyListeners();
  }

  bool isExist(Product product) {
    return _favourite.any((p) => p.id == product.id);
  }

  static FavouriteProvider of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<FavouriteProvider>(context, listen: listen);
  }
}
