import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/src/home.dart';

import '../services/api_service.dart';
import '../src/Register/emailverification.dart';
import '../src/menu.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    var result = await ApiService.loginUser(email, password);
    if (result.containsKey('accessToken')) {
      String? token = result['accessToken'];

      // 토큰 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', token!);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen()
        ),
      );
    } else {
      // 로그인 실패 처리
      print('로그인 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
            ),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            CustomButton(
              text: '로그인',
              onPressed: _login,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailVerificationPage()),
                );
              },
              child: Text('계정이 없으신가요? 회원가입하세요!'),
            ),
          ],
        ),
      ),
    );
  }
}
