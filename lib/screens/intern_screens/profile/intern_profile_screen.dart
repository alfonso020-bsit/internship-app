import 'package:flutter/material.dart';
import '../intern_navigation/intern_base_screen.dart';
import '../../../utils/theme_extension.dart';
import '../../../services/auth_service.dart';

class InternProfileScreen extends StatefulWidget {
  const InternProfileScreen({super.key});

  @override
  State<InternProfileScreen> createState() => _InternProfileScreenState();
}

class _InternProfileScreenState extends State<InternProfileScreen> {
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
      routeName: '/intern/profile',
      title: 'Profile',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: context.studentColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: context.studentColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userData?['name'] ?? 'Student Name',
                    style: context.heading3,
                  ),
                  Text(
                    _userData?['email'] ?? '',
                    style: context.bodyMedium.copyWith(
                      color: context.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Profile Details Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoTile(Icons.school, 'School', _userData?['school'] ?? 'Not set'),
                  _buildInfoTile(Icons.menu_book, 'Course', _userData?['course'] ?? 'Not set'),
                  _buildInfoTile(Icons.format_list_numbered, 'Year Level', '${_userData?['yearLevel'] ?? 'Not set'}'),
                  _buildInfoTile(Icons.phone, 'Contact', _userData?['contactNumber'] ?? 'Not set'),
                  _buildInfoTile(Icons.location_on, 'Address', _userData?['fullAddress'] ?? 'Not set'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
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
}