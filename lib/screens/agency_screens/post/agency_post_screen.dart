import 'package:flutter/material.dart';
import '../agency_navigation/agency_base_screen.dart';
import '../../../utils/theme_extension.dart';  // Fixed path

class AgencyPostScreen extends StatelessWidget {
  const AgencyPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AgencyBaseScreen(
      routeName: '/agency/post',
      title: 'Posts',
      child: Center(
        child: Text(
          'Post Management',
          style: context.heading3,
        ),
      ),
    );
  }
}