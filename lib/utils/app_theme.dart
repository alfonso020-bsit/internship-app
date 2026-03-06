import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Brand Colors
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color secondaryBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFFE3F2FD);
  
  static const Color primaryOrange = Color(0xFFF57C00);
  static const Color secondaryOrange = Color(0xFFFFB74D);
  static const Color lightOrange = Color(0xFFFFF3E0);
  
  static const Color primaryGreen = Color(0xFF388E3C);
  static const Color secondaryGreen = Color(0xFF66BB6A);
  static const Color lightGreen = Color(0xFFE8F5E9);
  
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color secondaryRed = Color(0xFFEF5350);
  static const Color lightRed = Color(0xFFFFEBEE);

  // Neutral Colors
  static const Color black = Color(0xFF212121);
  static const Color darkGrey = Color(0xFF757575);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);

  // Semantic Colors (based on user role)
  static const Color agencyColor = primaryOrange;
  static const Color studentColor = primaryGreen;
  static const Color adminColor = primaryBlue;

  // Status Colors
  static const Color success = primaryGreen;
  static const Color warning = primaryOrange;
  static const Color error = primaryRed;
  static const Color info = primaryBlue;
  static const Color pending = Color(0xFFFFA000);
  static const Color approved = Color(0xFF388E3C);
  static const Color rejected = Color(0xFFD32F2F);
  static const Color completed = Color(0xFF1976D2);

  // Text Styles - UPDATED with proper black colors
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: black,  // Changed to black
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: black,  // Changed to black
    letterSpacing: -0.5,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: black,  // Changed to black
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: black,  // Changed to black
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: black,  // Already black - good!
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: black,  // Changed from darkGrey to black
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: darkGrey,  // Keep this for secondary text (captions, hints)
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: white,  // Buttons should be white on colored background
    letterSpacing: 0.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: darkGrey,  // Keep grey for captions
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: darkGrey,  // Keep grey for overline
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryBlue,
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      secondary: primaryOrange,
      surface: white,
      background: backgroundGrey,
      error: primaryRed,
      onPrimary: white,
      onSecondary: white,
      onSurface: black,
      onBackground: black,
      onError: white,
    ),
    scaffoldBackgroundColor: backgroundGrey,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: white,
      ),
    ),
    cardTheme: const CardThemeData(  // FIXED: Changed CardTheme to CardThemeData
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),  // FIXED: Use BorderRadius.all
      ),
      color: white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: primaryBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: buttonText.copyWith(color: primaryBlue),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        textStyle: buttonText.copyWith(color: primaryBlue),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: lightGrey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: primaryBlue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: primaryRed),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    labelStyle: bodyMedium,
    hintStyle: bodyMedium.copyWith(color: grey),
    floatingLabelStyle: heading4.copyWith(color: primaryBlue), // ADD THIS
  ),

  // ADD THIS TEXT THEME
  textTheme: const TextTheme(
    displayLarge: heading1,
    displayMedium: heading2,
    displaySmall: heading3,
    headlineMedium: heading4,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: buttonText,
    labelMedium: caption,
    labelSmall: overline,
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: white,
    selectedItemColor: primaryBlue,
    unselectedItemColor: grey,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),

  tabBarTheme: const TabBarThemeData(
    labelColor: primaryBlue,
    unselectedLabelColor: grey,
    indicatorColor: primaryBlue,
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: primaryBlue,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: grey,
    ),
  ),

  dividerTheme: const DividerThemeData(
    color: lightGrey,
    thickness: 1,
    space: 1,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryBlue,
    foregroundColor: white,
  ),

  dialogTheme: const DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: black,
    ),
    contentTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: black,
    ),
  ),
  );

  // Dark Theme (Optional - can be implemented later)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryBlue,
    // Add dark theme configuration if needed
  );

  // Role-based theme extensions
  static ThemeData getAgencyTheme() {
    return lightTheme.copyWith(
      colorScheme: lightTheme.colorScheme.copyWith(
        primary: agencyColor,
        secondary: agencyColor,
      ),
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: agencyColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: agencyColor,
          foregroundColor: white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: agencyColor,
      ),
    );
  }

  static ThemeData getStudentTheme() {
    return lightTheme.copyWith(
      colorScheme: lightTheme.colorScheme.copyWith(
        primary: studentColor,
        secondary: studentColor,
      ),
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: studentColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: studentColor,
          foregroundColor: white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: studentColor,
      ),
    );
  }

  // Helper methods for consistent styling
  static BoxDecoration cardDecoration = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration gradientCardDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [primaryBlue.withOpacity(0.1), white],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: primaryBlue.withOpacity(0.2)),
  );

  static BoxDecoration statusDecoration(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withOpacity(0.3)),
    );
  }

  static TextStyle statusTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );
  }
}