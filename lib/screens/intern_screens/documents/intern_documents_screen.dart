import 'package:flutter/material.dart';
import '../intern_navigation/intern_base_screen.dart';
import '../../../utils/theme_extension.dart';

class InternDocumentsScreen extends StatelessWidget {
  const InternDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InternBaseScreen(
      routeName: '/intern/documents',
      title: 'Documents',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder,
              size: 80,
              color: context.studentColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'My Documents',
              style: context.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              'No documents uploaded yet',
              style: context.bodyMedium.copyWith(
                color: context.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Upload document
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.studentColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Upload Document'),
            ),
          ],
        ),
      ),
    );
  }
}