import 'package:flutter/material.dart';

class InternMenuItem {
  final String title;
  final String route;
  final IconData icon;
  final bool isLogout;

  const InternMenuItem({
    required this.title,
    required this.route,
    required this.icon,
    this.isLogout = false,
  });
}