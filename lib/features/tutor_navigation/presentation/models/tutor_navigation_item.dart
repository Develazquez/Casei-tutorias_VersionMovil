import 'package:flutter/material.dart';

class TutorNavigationItem {
  final String id;
  final String label;
  final IconData iconData;
  final IconData selectedIconData;
  final String? route;
  final bool enabled;
  final bool comingSoon;

  const TutorNavigationItem({
    required this.id,
    required this.label,
    required this.iconData,
    required this.selectedIconData,
    this.route,
    this.enabled = true,
    this.comingSoon = false,
  });
}
