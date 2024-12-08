import 'package:flutter/material.dart';

import 'package:facilities_info/src/menuSubPage/registerSubPage/registerFinal.dart';

import 'package:facilities_info/models/user.dart';
import 'package:facilities_info/Controller/authController.dart';

import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';

class RegisterPasswordPage extends StatefulWidget {
  final String email; // 이전 페이지에서 전달받은 이메일
  final String nickname; // 이전 페이지에서 전달받은 닉네임

  RegisterPasswordPage({required this.email, required this.nickname});

  @override
  _RegisterPasswordPageState createState() => _RegisterPasswordPageState();
}

class _RegisterPasswordPageState extends State<RegisterPasswordPage> {
  final TextEditingController passwordController = TextEditingController(); // 비밀번호 입력 컨트롤러
  final TextEditingController confirmPasswordController = TextEditingController(); // 비밀번호 확인 입력 컨트롤러
  final fontSizeManager = FontSizeManager(); // 폰트 크기 관리자

  String? passwordError; // 비밀번호 에러 메시지
  String? confirmPasswordError; // 비밀번호 확인 에러 메시지

  void _onNextPressed() async {
    setState(() {
      passwordError = null; // 초기화
      confirmPasswordError = null; // 초기화
    });

    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password.isEmpty) {
      setState(() {
        passwordError = "비밀번호를 입력해 주세요.";
      });
      return;
    }

    if (password.length < 8) {
      setState(() {
        passwordError = "비밀번호는 8자 이상이어야 합니다.";
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        confirmPasswordError = "비밀번호가 일치하지 않습니다.";
      });
      return;
    }

    try {
      User user = User(email: widget.email, password: password, nickname: widget.nickname);
      final result = await AuthController.registerLocalUser(user);

      if (result == "Register Finished") {
        _navigateToNext();
      }
    } catch (e) {
      return;
    }
  }

  void _navigateToNext() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterFinalPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.fontSecondary),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기
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
                    SizedBox(height: 85),

                    // 안내 텍스트
                    Text(
                      "비밀번호를\n설정해 주세요",
                      style: TextStyle(
                        color: AppColors.fontPrimary,
                        fontSize: fontSizeManager.fontSize + 2, // 기본 크기 + 2
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 30),

                    // 이메일 표시 필드 (ReadOnly)
                    TextField(
                      readOnly: true, // 읽기 전용
                      controller: TextEditingController(text: widget.email), // 이메일 표시
                      decoration: InputDecoration(
                        labelText: "이메일",
                        labelStyle: TextStyle(
                          color: AppColors.fontTertiary,
                          fontSize: fontSizeManager.fontSize,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.lineColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    // 닉네임 표시 필드 (ReadOnly)
                    TextField(
                      readOnly: true, // 읽기 전용
                      controller: TextEditingController(text: widget.nickname), // 닉네임 표시
                      decoration: InputDecoration(
                        labelText: "닉네임",
                        labelStyle: TextStyle(
                          color: AppColors.fontTertiary,
                          fontSize: fontSizeManager.fontSize,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.lineColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    // 비밀번호 입력 필드
                    TextField(
                      controller: passwordController,
                      obscureText: true, // 비밀번호 숨김 처리
                      decoration: InputDecoration(
                        labelText: "비밀번호",
                        labelStyle: TextStyle(
                          color: AppColors.fontTertiary,
                          fontSize: fontSizeManager.fontSize,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.lineColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                        ),
                        errorText: passwordError, // 비밀번호 에러 메시지
                        errorStyle: TextStyle(
                          color: AppColors.errorColor,
                          fontSize: fontSizeManager.fontSize - 2, // 기본 크기 - 2
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    // 비밀번호 확인 입력 필드
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true, // 비밀번호 숨김 처리
                      decoration: InputDecoration(
                        labelText: "비밀번호 다시 입력",
                        labelStyle: TextStyle(
                          color: AppColors.fontTertiary,
                          fontSize: fontSizeManager.fontSize,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.lineColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor),
                        ),
                        errorText: confirmPasswordError, // 비밀번호 확인 에러 메시지
                        errorStyle: TextStyle(
                          color: AppColors.errorColor,
                          fontSize: fontSizeManager.fontSize - 2, // 기본 크기 - 2
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    Spacer(),

                    // 다음 버튼
                    FI_MainButton(
                      text: "다음",
                      onPressed: _onNextPressed, // 다음 버튼 클릭 로직
                      backgroundColor: Colors.white, // 버튼 배경 투명
                      borderColor: AppColors.mainColor, // 테두리 색상
                      textColor: AppColors.mainColor, // 텍스트 색상
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
