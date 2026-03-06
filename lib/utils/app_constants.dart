class AppConstants {
  // App Info
  static const String appName = 'InternTrack';
  static const String appVersion = '1.0.0';
  
  // Collections
  static const String usersCollection = 'users';
  static const String agenciesCollection = 'agencies';
  static const String studentsCollection = 'students';
  static const String internshipPostsCollection = 'internship_posts';
  static const String applicationsCollection = 'applications';
  static const String dailyTimeRecordsCollection = 'daily_time_records';
  
  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String agencyDashboardRoute = '/agency/dashboard';
  static const String agencyPostsRoute = '/agency/posts';
  static const String agencyApplicantsRoute = '/agency/applicants';
  static const String agencyInternsRoute = '/agency/interns';
  static const String agencyProfileRoute = '/agency/profile';
  static const String studentDashboardRoute = '/student/dashboard';
  
  // Shared Preferences Keys
  static const String themePrefKey = 'theme_mode';
  static const String userRolePrefKey = 'user_role';
  
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'MMM dd, yyyy hh:mm a';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxAddressLength = 200;
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}