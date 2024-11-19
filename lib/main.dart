import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'src/home.dart';

import 'SingleTone/font.dart';
import 'SingleTone/deviceInfo.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/env/.env');
  AuthRepository.initialize(
    appKey: dotenv.env['KAKAO_APP_KEY'] ?? '',
  );

  // FontSizeManager 초기화
  await FontSizeManager().initialize();

  // DeviceInfo 초기화
  await DeviceInfo().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      theme: ThemeData(
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
      ),
    );
  }
}