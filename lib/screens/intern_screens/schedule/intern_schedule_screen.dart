import 'package:flutter/material.dart';
import '../intern_navigation/intern_base_screen.dart';
import '../../../utils/theme_extension.dart';

class InternScheduleScreen extends StatelessWidget {
  const InternScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InternBaseScreen(
      routeName: '/intern/schedule',
      title: 'Schedule',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 80,
              color: context.studentColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'My Schedule',
              style: context.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              'No scheduled activities yet',
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