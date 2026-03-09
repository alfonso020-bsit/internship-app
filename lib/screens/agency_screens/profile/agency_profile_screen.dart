import 'package:flutter/material.dart';
import '../agency_navigation/agency_base_screen.dart';
import '../../../utils/theme_extension.dart';  // Fixed path


class AgencyProfileScreen extends StatelessWidget {
  const AgencyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AgencyBaseScreen(
      routeName: '/agency/profile',
      title: 'Profile',
      child: Center(
        child: Text(
          'Agency Profile',
          style: context.heading3,
        ),
      ),
    );
  }
}