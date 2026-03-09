import 'package:flutter/material.dart';
import '../agency_navigation/agency_base_screen.dart';
import '../../../utils/theme_extension.dart';  // Fixed path


class AgencyInternsScreen extends StatelessWidget {
  const AgencyInternsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AgencyBaseScreen(
      routeName: '/agency/interns',
      title: 'Interns',
      child: Center(
        child: Text(
          'Interns Management',
          style: context.heading3,
        ),
      ),
    );
  }
}