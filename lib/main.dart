
import 'package:facilities_info/src/RecentSearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'src/map.dart';
import 'src/menu.dart';

import 'SingleTone/font.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/env/.env');
  AuthRepository.initialize(
    appKey: dotenv.env['KAKAO_APP_KEY'] ?? '',
  );

  // FontSizeManager 초기화
  await FontSizeManager().initialize();

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MapScreen() ,
    RecentSearchScreen(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '메뉴',
          ),
        ],
      ),
    );
  }
}
/*
import 'package:flutter/material.dart';
import 'Controller/facilities_search_page.dart';
import 'Controller/geo_coordinates_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facilities and Geo Coordinates',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FacilitiesSearchPage()),
                );
              },
              child: Text('Facilities Search'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeoCoordinatesPage()),
                );
              },
              child: Text('Geo Coordinates'),
            ),
          ],
        ),
      ),
    );
  }
}*/