import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'KoddiUDOnGothic',
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      useMaterial3: true,
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
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'KoddiUDOnGothic',
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueAccent,
        brightness: Brightness.dark,
      ),
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
    );
  }
}
