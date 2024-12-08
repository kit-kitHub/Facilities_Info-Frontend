import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'src/home.dart';

import 'SingleTone/fontSizeManager.dart';
import 'SingleTone/deviceInfo.dart';

import 'theme/theme.dart';

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
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system,
    );
  }
}