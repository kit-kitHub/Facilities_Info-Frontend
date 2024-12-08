import 'package:flutter/material.dart';

import 'package:facilities_info/styles/color.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Font 관련
      fontFamily: 'KoddiUDOnGothic',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'KoddiUDOnGothic'),
        bodyMedium: TextStyle(fontFamily: 'KoddiUDOnGothic'),
        bodySmall: TextStyle(fontFamily: 'KoddiUDOnGothic'),
      ),
      primaryTextTheme: const TextTheme(
        headlineLarge: TextStyle(fontFamily: 'KoddiUDOnGothic'),
        headlineMedium: TextStyle(fontFamily: 'KoddiUDOnGothic'),
        headlineSmall: TextStyle(fontFamily: 'KoddiUDOnGothic'),
      ),

      // Color 관련
      colorScheme: ColorScheme(
        primary: AppColors.mainColor, // Main Color
        onPrimary: Colors.white,
        secondary: AppColors.fontSecondary, // Font Secondary
        onSecondary: Colors.white,
        error: AppColors.errorColor, // Error Color
        onError: Colors.white,
        background: Colors.white,
        onBackground: AppColors.fontPrimary, // Font Primary
        surface: Colors.white,
        onSurface: AppColors.fontTertiary, // Font Tertiary
        brightness: Brightness.light,
      ),

      // Custom Colors
      primaryColor: AppColors.mainColor, // Main Color

      // Divider or Line Color
      dividerColor: AppColors.lineColor, // Line Color
    );
  }
}
