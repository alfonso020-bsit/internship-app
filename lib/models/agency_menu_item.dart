import 'package:flutter/material.dart';

class AgencyMenuItem {
  final String title;
  final String route;
  final IconData icon;
  final bool isLogout;

  AgencyMenuItem({
    required this.title,
    required this.route,
    required this.icon,
    this.isLogout = false,
  });
}