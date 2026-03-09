import 'package:flutter/material.dart';
import '../agency_navigation/agency_base_screen.dart';
import '../../../utils/theme_extension.dart';
import '../../../services/auth_service.dart';

class AgencyDashboardScreen extends StatefulWidget {
  const AgencyDashboardScreen({super.key});

  @override
  State<AgencyDashboardScreen> createState() => _AgencyDashboardScreenState();
}

class _AgencyDashboardScreenState extends State<AgencyDashboardScreen> {
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
    final role = await _authService.getUserRole();
    
    setState(() {
      _userData = user;
      _isLoading = false;
    });

    // Verify this is actually an agency user
    if (role != 'agency') {
      // Redirect to login if not agency
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AgencyBaseScreen(
      routeName: '/agency/dashboard',
      title: 'Dashboard',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message with agency name - FIXED: removed ?.
            Text(
              'Welcome back, ${_userData?['agencyName'] ?? _userData?['name'] ?? 'Agency'}!',
              style: context.heading2,
            ),
            const SizedBox(height: 8),
            
            // Agency details card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agency Details',
                      style: context.heading3,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.person, 'Contact Person', _userData?['contactPerson'] ?? 'N/A'),
                    _buildInfoRow(Icons.phone, 'Contact Number', _userData?['contactNumber'] ?? 'N/A'),
                    _buildInfoRow(Icons.location_on, 'Address', _userData?['fullAddress'] ?? 'N/A'),
                    // FIXED: Simplified verification check
                    if (_userData != null && _userData!['isVerified'] == true)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: const Text(
                          '✓ Verified Agency',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'Here\'s what\'s happening with your agency today.',
              style: context.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  context,
                  'Total Interns',
                  '0',
                  Icons.people,
                  context.primaryBlue,
                ),
                _buildStatCard(
                  context,
                  'Active Posts',
                  '0',
                  Icons.post_add,
                  context.primaryOrange,
                ),
                _buildStatCard(
                  context,
                  'Applications',
                  '0',
                  Icons.assignment,
                  context.primaryGreen,
                ),
                _buildStatCard(
                  context,
                  'Reports',
                  '0',
                  Icons.bar_chart,
                  context.primaryRed,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Activity
            Text(
              'Recent Activity',
              style: context.heading3,
            ),
            const SizedBox(height: 16),
            _buildActivityTile(
              context,
              'Welcome to InternTrack',
              'Your agency dashboard is ready',
              'Just now',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
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
              // FIXED: context.heading3 is not nullable, so use . instead of ?.
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

  Widget _buildActivityTile(
    BuildContext context,
    String title,
    String subtitle,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.lightGrey),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  // FIXED: context.bodyLarge is not nullable
                  style: context.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: context.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            time,
            // FIXED: context.bodySmall is not nullable
            style: context.bodySmall.copyWith(
              color: context.grey,
            ),
          ),
        ],
      ),
    );
  }
}