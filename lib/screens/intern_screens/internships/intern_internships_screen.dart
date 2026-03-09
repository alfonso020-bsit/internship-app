import 'package:flutter/material.dart';
import '../intern_navigation/intern_base_screen.dart';
import '../../../utils/theme_extension.dart';

class InternInternshipsScreen extends StatelessWidget {
  const InternInternshipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InternBaseScreen(
      routeName: '/intern/internships',
      title: 'Internships',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work,
              size: 80,
              color: context.studentColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Available Internships',
              style: context.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              'Browse internships from agencies',
              style: context.bodyMedium.copyWith(
                color: context.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to browse internships
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.studentColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Browse Internships'),
            ),
          ],
        ),
      ),
    );
  }
}