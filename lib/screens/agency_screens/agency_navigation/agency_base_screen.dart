import 'package:flutter/material.dart';

class AgencyBaseScreen extends StatelessWidget {
  final Widget child;
  final String routeName;
  final List<Widget>? appBarActions;
  final String? title;

  const AgencyBaseScreen({
    super.key,
    required this.child,
    required this.routeName,
    this.appBarActions,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    // This now just returns the child, since the navigation is handled by the provider
    return child;
  }
}