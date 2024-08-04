import 'package:flutter/material.dart';
import 'package:hackathon_project/model/product_model.dart';
import 'package:provider/provider.dart';

class FavouriteProvider extends ChangeNotifier {
  final List<ProductModel> _favourite = [];
  List<ProductModel> get favourites => _favourite;
  void toggleFavourite(ProductModel product) {
    if (_favourite.contains(product)) {
      _favourite.remove(product);
    } else {
      _favourite.add(product);
    }
    notifyListeners();
  }

  bool isExist(ProductModel product) {
    final isExist = _favourite.contains(product);
    return isExist;
  }

  static FavouriteProvider of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<FavouriteProvider>(context, listen: listen);
  }
}
