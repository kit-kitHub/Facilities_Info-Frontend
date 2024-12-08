import 'package:flutter/material.dart';

import 'package:facilities_info/src/menuSubPage/registerSubPage/registerVerifyEmail.dart';

import 'package:facilities_info/Controller/authController.dart';

import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final fontSizeManager = FontSizeManager(); // FontSizeManager 로드

  String? emailError; // 이메일 필드 에러 메시지

  /// 이메일 형식 검사 함수
  bool _isEmailValid(String email) {
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'); // 이메일 형식 정규식
    return emailRegex.hasMatch(email);
  }

  void _onNextPressed() async {
    String email = emailController.text;

    setState(() {
      emailError = null; // 초기화
    });

    if (!_isEmailValid(email)) {
      setState(() {
        emailError = "올바른 이메일 형식이 아닙니다.";
      });
      return;
    }

    try {
      final result = await AuthController.checkEmail(email);

      if (result == "Available email") {
        _sendVerificationEmail(email);
      } else if (result == "Email already in use") {
        emailError = "이미 사용 중인 이메일 입니다.";
        return;
      }
    } catch (e) {
      emailError = "이메일 중복 확인 중 에러가 발생했습니다.";
      return;
    }
  }
  
  void _sendVerificationEmail(String email) {
    // TODO : 인증 메일 발송 로직 추가
    
    
    _navigateToNext(email);
  }

  void _navigateToNext(String email) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterVerifyEmailPage(email: email)),
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 130),

            // 설명 텍스트
            Text(
              "회원가입을 위해\n이메일 인증을 진행해 주세요",
              style: TextStyle(
                color: AppColors.fontPrimary, // Font Primary Color 적용
                fontSize: fontSizeManager.fontSize + 2, // 기본 크기 + 2
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 30),

            // 이메일 입력 필드
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
                  borderSide: BorderSide(color: AppColors.lineColor), // Line Color 적용
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainColor), // Main Color 적용
                ),
                errorText: emailError, // 이메일 에러 메시지
                errorStyle: TextStyle(
                  color: AppColors.errorColor,
                  fontSize: fontSizeManager.fontSize - 2, // 기본 크기 - 2
                ),
              ),
            ),

            Spacer(),

            // 다음 버튼
            FI_MainButton(
              text: "다음",
              onPressed: _onNextPressed,
              backgroundColor: Colors.white, // 버튼 배경 투명
              borderColor: AppColors.mainColor, // 테두리 색상
              textColor: AppColors.mainColor, // 텍스트 색상
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
