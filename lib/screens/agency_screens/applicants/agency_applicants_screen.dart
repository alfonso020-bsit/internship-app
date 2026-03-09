import 'package:flutter/material.dart';
import '../agency_navigation/agency_base_screen.dart';
import '../../../utils/theme_extension.dart';  // Fixed path

class AgencyApplicantsScreen extends StatelessWidget {
  const AgencyApplicantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AgencyBaseScreen(
      routeName: '/agency/applicants',
      title: 'Applicants',
      child: Center(
        child: Text(
          'Applicants Management',
          style: context.heading3,
        ),
      ),
    );
  }
}