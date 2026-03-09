import 'package:flutter/material.dart';
import '../agency_navigation/agency_base_screen.dart';
import '../../../utils/theme_extension.dart';  // Fixed path

class AgencyReportsScreen extends StatelessWidget {
  const AgencyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AgencyBaseScreen(
      routeName: '/agency/reports',
      title: 'Reports',
      child: Center(
        child: Text(
          'Reports',
          style: context.heading3,
        ),
      ),
    );
  }
}