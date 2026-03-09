import 'package:flutter/material.dart';

class InternBaseScreen extends StatelessWidget {
  final Widget child;
  final String routeName;
  final List<Widget>? appBarActions;
  final String? title;

  const InternBaseScreen({
    super.key,
    required this.child,
    required this.routeName,
    this.appBarActions,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}