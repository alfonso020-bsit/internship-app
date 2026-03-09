import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth/login_screen.dart';

// Agency screens - make sure these match your actual filenames
import 'screens/agency_screens/dashboard/agency_dashboard_screen.dart';
import 'screens/agency_screens/interns/agency_interns_screen.dart';
import 'screens/agency_screens/applicants/agency_applicants_screen.dart';
import 'screens/agency_screens/post/agency_post_screen.dart';
import 'screens/agency_screens/profile/agency_profile_screen.dart';
import 'screens/agency_screens/reports/agency_reports_screen.dart';

import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InternTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        
        // Make sure these route names match what you use in navigation
        '/agency/dashboard': (context) => const AgencyDashboardScreen(),
        '/agency/interns': (context) => const AgencyInternsScreen(),
        '/agency/applicants': (context) => const AgencyApplicantsScreen(),
        '/agency/post': (context) => const AgencyPostScreen(),
        '/agency/profile': (context) => const AgencyProfileScreen(),
        '/agency/reports': (context) => const AgencyReportsScreen(),
      },
    );
  }
}