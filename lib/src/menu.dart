import 'package:flutter/material.dart';
import 'Info.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // MY Text
              const Text(
                'MY',
                style: TextStyle(
                  fontSize: 24,
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
              const Text(
                '닉네임',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              // Login Button
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  '로그인하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
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
            Icon(icon, size: 20, color: Colors.black54),
            SizedBox(width: 12),
            Text(title, style: TextStyle(color: Colors.black87, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}