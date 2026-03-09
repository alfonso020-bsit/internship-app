import 'package:flutter/material.dart';
import '../intern_navigation/intern_base_screen.dart';
import '../../../utils/theme_extension.dart';

class InternApplicationsScreen extends StatelessWidget {
  const InternApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InternBaseScreen(
      routeName: '/intern/applications',
      title: 'Applications',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment,
              size: 80,
              color: context.studentColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'My Applications',
              style: context.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              'No applications yet',
              style: context.bodyMedium.copyWith(
                color: context.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}