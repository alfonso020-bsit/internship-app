import 'package:flutter/material.dart';

class InternNavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateRoute(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}