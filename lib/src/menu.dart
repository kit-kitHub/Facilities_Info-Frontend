import 'package:flutter/material.dart';

import 'package:facilities_info/src/menuSubPage/login.dart';
import 'package:facilities_info/src/menuSubPage/Info.dart';

import '/SingleTone/fontSizeManager.dart';

import 'InquriyScreen.dart';
import 'NoticeListPage.dart';
import 'Info.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreen();
}

class _MenuScreen extends State<MenuScreen> {
  final fontSizeManager = FontSizeManager(); // FontSizeManager 로드
  String? nickname; // 닉네임 변수
  bool isLoggedIn = false; // 로그인 상태 확인

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // SharedPreferences를 사용하여 로그인 상태 확인
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedNickname = prefs.getString('nickname');
    String? token = prefs.getString('accessToken');

    setState(() {
      nickname = storedNickname;
      isLoggedIn = token != null; // 토큰이 있으면 로그인 상태
    });
  }

  Future<void> _logout() async {
    // 로그아웃 처리: SharedPreferences에서 accessToken 제거
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken'); // 토큰 제거
    await prefs.remove('nickname'); // 닉네임 제거

    setState(() {
      nickname = null;
      isLoggedIn = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('로그아웃 되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar
      appBar: AppBar(
        title: const Text('메뉴'),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: () {
              setState(() {
                fontSizeManager.decreaseFontSize();
              });
            },
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
            icon: const Icon(Icons.text_increase),
            onPressed: () {
              setState(() {
                fontSizeManager.increaseFontSize();
              });
            },
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
                  fontSize: fontSizeManager.fontSize + 8,
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
                nickname ?? '로그인 필요',
                style: TextStyle(
                  fontSize: fontSizeManager.fontSize + 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Login / Logout Button
              if (!isLoggedIn) // 로그인이 안 되어 있을 때
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    ).then((value) {
                      _checkLoginStatus(); // 로그인 후 상태 업데이트
                    });
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
                )
              else // 로그인이 되어 있을 때
                OutlinedButton(
                  onPressed: _logout,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    '로그아웃',
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
                ),
              ),
              const Divider(height: 1),
              _buildMenuItem(Icons.info_outline, '정보',
                    () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InfoScreen()),
                ),
              ),
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
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(color: Colors.black87, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
