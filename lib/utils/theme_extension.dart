import 'package:flutter/material.dart';
import 'app_theme.dart';

extension ThemeExtensions on BuildContext {
  // Get theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  
  // ===== COLOR GETTERS =====
  // Brand Colors
  Color get primaryBlue => AppTheme.primaryBlue;
  Color get secondaryBlue => AppTheme.secondaryBlue;
  Color get lightBlue => AppTheme.lightBlue;
  
  Color get primaryOrange => AppTheme.primaryOrange;
  Color get secondaryOrange => AppTheme.secondaryOrange;
  Color get lightOrange => AppTheme.lightOrange;
  
  Color get primaryGreen => AppTheme.primaryGreen;
  Color get secondaryGreen => AppTheme.secondaryGreen;
  Color get lightGreen => AppTheme.lightGreen;
  
  Color get primaryRed => AppTheme.primaryRed;
  Color get secondaryRed => AppTheme.secondaryRed;
  Color get lightRed => AppTheme.lightRed;
  
  // Neutral Colors
  Color get black => AppTheme.black;
  Color get dark => AppTheme.black; // Alias for black
  Color get darkGrey => AppTheme.darkGrey;
  Color get grey => AppTheme.grey;
  Color get lightGrey => AppTheme.lightGrey;
  Color get backgroundGrey => AppTheme.backgroundGrey;
  Color get white => AppTheme.white;
  Color get medium => AppTheme.darkGrey; // Alias for medium/darkGrey
  
  // Semantic Colors
  Color get agencyColor => AppTheme.agencyColor;
  Color get studentColor => AppTheme.studentColor;
  Color get adminColor => AppTheme.adminColor;
  Color get green => AppTheme.agencyColor; // Alias for agency color
  
  // Status Colors
  Color get success => AppTheme.success;
  Color get warning => AppTheme.warning;
  Color get error => AppTheme.error;
  Color get info => AppTheme.info;
  Color get pending => AppTheme.pending;
  Color get approved => AppTheme.approved;
  Color get rejected => AppTheme.rejected;
  Color get completed => AppTheme.completed;
  
  // ===== TEXT STYLE GETTERS =====
  TextStyle get heading1 => AppTheme.heading1;
  TextStyle get heading2 => AppTheme.heading2;
  TextStyle get heading3 => AppTheme.heading3;
  TextStyle get heading4 => AppTheme.heading4;
  
  TextStyle get bodyLarge => AppTheme.bodyLarge;
  TextStyle get bodyMedium => AppTheme.bodyMedium;
  TextStyle get bodySmall => AppTheme.bodySmall;
  
  TextStyle get buttonText => AppTheme.buttonText;
  TextStyle get caption => AppTheme.caption;
  TextStyle get overline => AppTheme.overline;
  
  // ===== DECORATION GETTERS =====
  BoxDecoration get cardDecoration => AppTheme.cardDecoration;
  BoxDecoration get gradientCardDecoration => AppTheme.gradientCardDecoration;
  
  BoxDecoration statusDecoration(Color color) => 
      AppTheme.statusDecoration(color);
  
  TextStyle statusTextStyle(Color color) => 
      AppTheme.statusTextStyle(color);
}