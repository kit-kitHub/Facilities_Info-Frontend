import 'package:flutter/material.dart';

import 'package:facilities_info/src/menuSubPage/registerSubPage/registerPassword.dart';

import 'package:facilities_info/Controller/authController.dart';

import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';

class RegisterNicknamePage extends StatefulWidget {
  final String email; // 이전 페이지에서 전달받은 이메일

  RegisterNicknamePage({required this.email});

  @override
  _RegisterNicknamePageState createState() => _RegisterNicknamePageState();
}

class _RegisterNicknamePageState extends State<RegisterNicknamePage> {
  final TextEditingController nicknameController = TextEditingController(); // 닉네임 입력 컨트롤러
  final fontSizeManager = FontSizeManager(); // 폰트 크기 관리자

  String? nicknameError; // 닉네임 에러 메시지

  void _onNextPressed() async {
    setState(() {
      nicknameError = null; // 초기화
    });

    String nickname = nicknameController.text;

    if (nickname.isEmpty) {
      setState(() {
        nicknameError = "닉네임을 입력해 주세요.";
      });
      return;
    }

    // TODO : 백엔드 배포된 버전에 checkNickname이 없음 아직
    // try {
    //   final result = await AuthController.checkNickname(nickname);
    //
    //   if (result == "Available nickname") {
    //     _navigateToNext(nickname);
    //   } else if (result == "Nickname already in use") {
    //     nicknameError = "이미 사용 중인 닉네임 입니다.";
    //     return;
    //   }
    // } catch (e) {
    //   nicknameError = "닉네임 중복 확인 중 에러가 발생했습니다.";
    //   return;
    // }

    // TEST용
    _navigateToNext(nickname);

  }

  void _navigateToNext(String nickname) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPasswordPage(email: widget.email, nickname: nickname)),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 85),

            // 안내 텍스트
            Text(
              "닉네임을\n입력해 주세요",
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

            // 닉네임 입력 필드
            TextField(
              controller: nicknameController,
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
                errorText: nicknameError, // 닉네임 에러 메시지
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
              onPressed: _onNextPressed, // 다음 버튼 클릭 로직
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
