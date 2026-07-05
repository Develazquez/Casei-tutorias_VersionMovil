import 'package:flutter/material.dart';

class SegmentationNavigationViewModel extends ChangeNotifier {
  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  void setTab(int index) {
    if (index < 0 || index > 2) return;
    _currentTabIndex = index;
    notifyListeners();
  }
}
