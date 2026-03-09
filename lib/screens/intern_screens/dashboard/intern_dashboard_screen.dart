import 'package:flutter/material.dart';
import '../intern_navigation/intern_base_screen.dart';
import '../../../utils/theme_extension.dart';
import '../../../services/auth_service.dart';

class InternDashboardScreen extends StatefulWidget {
  const InternDashboardScreen({super.key});

  @override
  State<InternDashboardScreen> createState() => _InternDashboardScreenState();
}

class _InternDashboardScreenState extends State<InternDashboardScreen> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _authService.getUser();
    setState(() {
      _userData = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return InternBaseScreen(
      routeName: '/intern/dashboard',
      title: 'Dashboard',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${_userData?['name'] ?? 'Intern'}!',
              style: context.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              'Track your internship journey here.',
              style: context.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Stats cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  'Applications',
                  '3',
                  Icons.assignment,
                  context.primaryBlue,
                ),
                _buildStatCard(
                  'Active',
                  '1',
                  Icons.work,
                  context.primaryGreen,
                ),
                _buildStatCard(
                  'Completed',
                  '0',
                  Icons.check_circle,
                  context.primaryOrange,
                ),
                _buildStatCard(
                  'Documents',
                  '5',
                  Icons.folder,
                  context.primaryRed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: context.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const Spacer(),
            Text(
              value,
              style: context.heading3.copyWith(color: color),
            ),
            Text(
              label,
              style: context.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}