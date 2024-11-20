import 'package:flutter/material.dart';

import '/SingleTone/authService.dart';
import '/SingleTone/fontSizeManager.dart';

import 'menuSubPage/Info.dart';

import '/src/accountManagePage/account_widget.dart';
import '/src/accountManagePage/memberLogin.dart';



class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreen();
}

class _MenuScreen extends State<MenuScreen> {
  final fontSizeManager = FontSizeManager();  // FontSizeManager 로드
  final authService = AuthService();          // AuthService 로드

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar
      appBar: AppBar(
        title: Text('메뉴'),
        actions: [
          IconButton(
            icon: Icon(Icons.text_decrease),
            onPressed: () { setState(() { fontSizeManager.decreaseFontSize(); }); },
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 16.0),
          //   child: Center(
          //     child: Text(
          //       fontSizeManager.fontSize.toStringAsFixed(0),
          //       style: TextStyle(fontSize: fontSizeManager.fontSize),
          //     ),
          //   ),
          // ),
          IconButton(
            icon: Icon(Icons.text_increase),
            onPressed: () { setState(() { fontSizeManager.increaseFontSize(); }); },
          ),
        ],
      ),


      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // const SizedBox(height: 20),

              AccountWidget(),

              const SizedBox(height: 40),
              // Menu Items
              _buildMenuItem(Icons.notifications_none_outlined, '공지사항',
                    () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InfoScreen()),
                ),
              ),
              const Divider(height: 1),
              _buildMenuItem(Icons.chat_bubble_outline, '문의하기',
                    () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InfoScreen()),
                ),),
              const Divider(height: 1),
              _buildMenuItem(Icons.info_outline, '정보',
                    () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InfoScreen()),
                ),),
              const Divider(height: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextButton(
        onPressed: () {
          onPressed();
        },
        child: Row(
          children: [
            Icon(icon, size: fontSizeManager.fontSize + 6, color: Colors.black54),
            SizedBox(width: 12),
            Text(title, style: TextStyle(color: Colors.black87, fontSize: fontSizeManager.fontSize)),
          ],
        ),
      ),
    );
  }
}

