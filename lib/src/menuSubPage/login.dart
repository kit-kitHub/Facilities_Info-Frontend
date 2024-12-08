import 'package:flutter/material.dart';

import 'package:facilities_info/src/home.dart';
import 'package:facilities_info/src/menuSubPage/register.dart';

import 'package:facilities_info/Controller/authController.dart';

import 'package:facilities_info/SingleTone/tokenManager.dart';
import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final tokenManager = TokenManager();
  final fontSizeManager = FontSizeManager();

  String? emailError; // 이메일 필드 에러 메시지
  String? passwordError; // 비밀번호 필드 에러 메시지

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'); // 이메일 형식 정규식
    return emailRegex.hasMatch(email);
  }

  void _login() async {
    String email = emailController.text;
    String password = passwordController.text;

    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (!_isEmailValid(email)) {
      setState(() {
        emailError = "올바른 이메일 형식이 아닙니다.";
      });
      return;
    }

    try {
      final result = await AuthController.loginUser(email, password);

      if (result is Map<String, String>) {
        tokenManager.setAccessToken(result['AccessToken']!);
        tokenManager.setRefreshToken(result['RefreshToken']!);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else if (result == "Invalid password") {
        setState(() {
          passwordError = "비밀번호가 일치하지 않습니다.";
        });
      } else if (result == "User not found") {
        setState(() {
          emailError = "해당 이메일을 찾을 수 없습니다.";
        });
      }
    } catch (e) {
      print("로그인 중 오류 발생: $e");
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()), // RegisterPage로 이동
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.fontSecondary), // Font Secondary Color 적용
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 130),

                    Text(
                      "로그인",
                      style: TextStyle(
                        color: AppColors.fontPrimary,
                        fontSize: fontSizeManager.fontSize + 8, // 기본 크기 + 8
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 30),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "이메일",
                        labelStyle: TextStyle(
                          color: AppColors.fontTertiary,
                          fontSize: fontSizeManager.fontSize, // 기본 폰트 크기 적용
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.lineColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                        ),
                        errorText: emailError,
                        errorStyle: TextStyle(
                          color: AppColors.errorColor,
                          fontSize: fontSizeManager.fontSize - 2, // 기본 크기 - 2
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "비밀번호",
                        labelStyle: TextStyle(
                          color: AppColors.fontTertiary,
                          fontSize: fontSizeManager.fontSize, // 기본 폰트 크기 적용
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.lineColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                        ),
                        errorText: passwordError,
                        errorStyle: TextStyle(
                          color: AppColors.errorColor,
                          fontSize: fontSizeManager.fontSize - 2, // 기본 크기 - 2
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            // 비밀번호 찾기 페이지로 이동
                          },
                          child: Text(
                            "비밀번호 찾기",
                            style: TextStyle(
                              color: AppColors.fontSecondary,
                              fontSize: fontSizeManager.fontSize - 2, // 기본 크기 - 2
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _navigateToRegister, // RegisterPage로 이동
                          child: Text(
                            "회원가입",
                            style: TextStyle(
                              color: AppColors.fontSecondary,
                              fontSize: fontSizeManager.fontSize - 2, // 기본 크기 - 2
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

                    Spacer(),

                    FI_MainButton(
                      text: "로그인",
                      onPressed: _login,
                      backgroundColor: AppColors.mainColor, // Main Color
                      textColor: Colors.white, // 텍스트 색상
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
