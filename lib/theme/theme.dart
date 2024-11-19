import 'package:flutter/material.dart';

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
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),

      primaryColor: Colors.blue,
    );
  }
}
