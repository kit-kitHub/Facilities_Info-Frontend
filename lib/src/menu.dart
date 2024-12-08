import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import 'Info.dart';

import '/SingleTone/fontSizeManager.dart';
import 'InquriyScreen.dart';
import 'NoticeListPage.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreen();
}

class _MenuScreen extends State<MenuScreen> {
  final fontSizeManager = FontSizeManager();  // FontSizeManager 로드

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                fontSizeManager.fontSize.toStringAsFixed(0),
                style: TextStyle(fontSize: fontSizeManager.fontSize),
              ),
            ),
          ),
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
              const SizedBox(height: 40),

              // MY Text
              Text(
                'MY',
                style: TextStyle(
                  fontSize: fontSizeManager.fontSize + 8, // default : 24
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Profile Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 50,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              // Nickname
              Text(
                '닉네임',
                style: TextStyle(
                  fontSize: fontSizeManager.fontSize + 2, // default : 18
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              // Login Button
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  '로그인하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSizeManager.fontSize,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Menu Items
              _buildMenuItem(Icons.notifications_none_outlined, '공지사항',
                    () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NoticeListPage()),
                ),
              ),
              const Divider(height: 1),
              _buildMenuItem(Icons.chat_bubble_outline, '문의하기',
                    () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InquiryScreen()),
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
            Icon(icon, size: 20, color: Colors.black54),
            SizedBox(width: 12),
            Text(title, style: TextStyle(color: Colors.black87, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

