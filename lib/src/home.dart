import 'package:flutter/material.dart';

import 'package:facilities_info/src/map.dart';
import 'package:facilities_info/src/search.dart';
import 'package:facilities_info/src/menu.dart';

import 'package:facilities_info/src/RecentSearchScreen.dart';


class HomeScreen extends StatefulWidget {
  final int currentIndex;

  const HomeScreen({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const MapScreen() ,
    RecentSearchScreen(),
    const MenuScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    const BottomNavigationBarItem(label: '지도', icon: Icon(Icons.map),),
    const BottomNavigationBarItem(label: '검색', icon: Icon(Icons.search),),
    const BottomNavigationBarItem(label: '메뉴', icon: Icon(Icons.menu),),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

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
