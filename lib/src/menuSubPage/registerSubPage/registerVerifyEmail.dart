import 'package:flutter/material.dart';

import 'package:facilities_info/src/menuSubPage/registerSubPage/registerNickname.dart';

import 'package:facilities_info/Controller/authController.dart';

import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';

class RegisterVerifyEmailPage extends StatefulWidget {
  final String email; // RegisterPage에서 전달받는 이메일

  RegisterVerifyEmailPage({required this.email});

  @override
  _RegisterVerifyEmailPageState createState() => _RegisterVerifyEmailPageState();
}

class _RegisterVerifyEmailPageState extends State<RegisterVerifyEmailPage> {
  final fontSizeManager = FontSizeManager(); // 폰트 크기 관리자

  String? emailError; // 이메일 필드 에러 메시지


  void _onNextPressed() async {
    setState(() {
      emailError = null; // 초기화
    });

    try {
      // 이메일 인증 여부 확인
      final result = await AuthController.checkEmailVerification(widget.email);

      if (result == "Email is verified and token deleted") {
        // 이메일 인증 완료
        _navigateToNext();
      } else if (result == "Email is not verified") {
        // 이메일 인증 미완료
        setState(() {
          emailError = "이메일 인증이 완료되지 않았습니다.";
        });
        return;
      } else {
        setState(() {
          emailError = "알 수 없는 오류가 발생했습니다.";
        });
      }
    } catch (e) {
      setState(() {
        emailError = "이메일 인증 확인 중 에러가 발생했습니다.";
      });
    }
  }

  void _navigateToNext() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterNicknamePage(email: widget.email)),
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
              "인증 메일이 전송되었습니다.\n\n이메일 인증 완료 후\n다음 버튼을 눌러 계속해 주세요",
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
