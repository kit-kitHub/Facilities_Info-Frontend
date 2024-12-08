import 'package:flutter/material.dart';

import '/src/map.dart';
import '/src/search.dart';
import '/src/menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MapScreen() ,
    const SearchScreen(),
    const MenuScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(label: '지도', icon: Icon(Icons.map),),
    const BottomNavigationBarItem(label: '검색', icon: Icon(Icons.search),),
    const BottomNavigationBarItem(label: '메뉴', icon: Icon(Icons.menu),),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // body에 각각의 screen 표시
      body: _screens[_currentIndex],

      // bottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _bottomNavigationBarItems,
      ),
    );
  }
}
