import 'package:flutter/material.dart';

import '../../../../navigation/app_screen.dart';
import '../models/tutor_navigation_item.dart';

class TutorNavigationViewModel extends ChangeNotifier {
  TutorNavigationViewModel({String initialId = 'segmentation'}) {
    _selectedIndex = _items.indexWhere((item) => item.id == initialId);
    if (_selectedIndex == -1) _selectedIndex = 0;
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  final List<TutorNavigationItem> _items = [
    TutorNavigationItem(
      id: 'segmentation',
      label: 'Segmentación Tutorados',
      iconData: Icons.analytics_outlined,
      selectedIconData: Icons.analytics,
      route: AppScreen.segmentation.route,
    ),
  ];

  List<TutorNavigationItem> get items => _items;

  void setSelectedIndex(int index) {
    if (index < 0 || index >= _items.length) return;
    if (!_items[index].enabled && !_items[index].comingSoon) return;

    _selectedIndex = index;
    notifyListeners();
  }
}
