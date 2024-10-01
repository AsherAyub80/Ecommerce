import 'package:flutter/material.dart';

class PageIndexProvider extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void updatePage(int newIndex) {
    _currentPage = newIndex;
    notifyListeners();
  }
}
