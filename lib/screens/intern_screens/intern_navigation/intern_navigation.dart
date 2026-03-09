import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/theme_extension.dart';
import '../../../services/auth_service.dart';
import '../../../models/intern_menu_item.dart';
import 'intern_navigation_provider.dart';

// Import all intern screens
import '../dashboard/intern_dashboard_screen.dart';
import '../applications/intern_applications_screen.dart';
import '../internships/intern_internships_screen.dart';
import '../profile/intern_profile_screen.dart';
import '../documents/intern_documents_screen.dart';
import '../schedule/intern_schedule_screen.dart';

class InternNavigation extends StatefulWidget {
  final String currentRoute;

  const InternNavigation({
    super.key,
    required this.currentRoute,
  });

  @override
  State<InternNavigation> createState() => _InternNavigationState();
}

class _InternNavigationState extends State<InternNavigation> {
  final AuthService _authService = AuthService();
  
  late List<InternMenuItem> menuItems;
  late List<Widget> _screens;
  late List<String> _titles;

  @override
  void initState() {
    super.initState();
    
    // Initialize menu items
    menuItems = [
      InternMenuItem(
        title: 'Dashboard',
        route: '/intern/dashboard',
        icon: Icons.dashboard,
      ),
      InternMenuItem(
        title: 'Applications',
        route: '/intern/applications',
        icon: Icons.assignment,
      ),
      InternMenuItem(
        title: 'Internships',
        route: '/intern/internships',
        icon: Icons.work,
      ),
      InternMenuItem(
        title: 'Schedule',
        route: '/intern/schedule',
        icon: Icons.calendar_today,
      ),
      InternMenuItem(
        title: 'Documents',
        route: '/intern/documents',
        icon: Icons.folder,
      ),
      InternMenuItem(
        title: 'Profile',
        route: '/intern/profile',
        icon: Icons.person,
      ),
      InternMenuItem(
        title: 'Logout',
        route: '/logout',
        icon: Icons.logout,
        isLogout: true,
      ),
    ];

    // Initialize screens
    _screens = [
      const InternDashboardScreen(),
      const InternApplicationsScreen(),
      const InternInternshipsScreen(),
      const InternScheduleScreen(),
      const InternDocumentsScreen(),
      const InternProfileScreen(),
    ];

    _titles = [
      'Dashboard',
      'Applications',
      'Internships',
      'Schedule',
      'Documents',
      'Profile',
    ];

    // Set initial index based on currentRoute
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InternNavigationProvider>(context, listen: false);
      int initialIndex = _getIndexFromRoute(widget.currentRoute);
      provider.updateRoute(initialIndex);
    });
  }

  int _getIndexFromRoute(String route) {
    switch (route) {
      case '/intern/dashboard':
        return 0;
      case '/intern/applications':
        return 1;
      case '/intern/internships':
        return 2;
      case '/intern/schedule':
        return 3;
      case '/intern/documents':
        return 4;
      case '/intern/profile':
        return 5;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InternNavigationProvider(),
      child: Consumer<InternNavigationProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_titles[provider.currentIndex]),
              backgroundColor: context.studentColor, // Use student color from your theme
              foregroundColor: Colors.white,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
            drawer: _buildDrawer(context, provider),
            body: _screens[provider.currentIndex],
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, InternNavigationProvider provider) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = index == provider.currentIndex;
                
                if (item.isLogout) {
                  return _buildLogoutItem(context, item);
                }
                
                return _buildDrawerItem(context, item, isSelected, index, provider);
              },
            ),
          ),
          _buildDrawerFooter(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.studentColor,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: context.white,
              child: Icon(
                Icons.school,
                size: 35,
                color: context.studentColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Intern Portal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    InternMenuItem item,
    bool isSelected,
    int index,
    InternNavigationProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? context.studentColor.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          item.icon, 
          color: isSelected ? context.studentColor : context.dark,
          size: 24,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isSelected ? context.studentColor : context.dark,
          ),
        ),
        onTap: () {
          provider.updateRoute(index);
          Navigator.pop(context); // Close drawer
        },
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context, InternMenuItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          item.icon, 
          color: Colors.red,
          size: 24,
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.red,
          ),
        ),
        onTap: () => _showLogoutDialog(),
      ),
    );
  }

  Widget _buildDrawerFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Version 1.0.0',
        style: TextStyle(
          color: context.medium,
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: context.medium)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _authService.clear();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}