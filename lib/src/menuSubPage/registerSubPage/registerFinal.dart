import 'package:flutter/material.dart';

import 'package:facilities_info/src/menuSubPage/login.dart';

import 'package:facilities_info/SingleTone/fontSizeManager.dart';

import 'package:facilities_info/styles/color.dart';
import 'package:facilities_info/widgets/fi_mainButton.dart';

class RegisterFinalPage extends StatelessWidget {
  final fontSizeManager = FontSizeManager(); // 폰트 크기 관리자

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: AppColors.fontSecondary),
        //   onPressed: () {
        //     Navigator.pop(context); // 뒤로가기
        //   },
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 130),

            // 완료 메시지 텍스트
            Text(
              "회원가입이 완료되었습니다!\n\n아래 버튼을 통해\n로그인 페이지로 이동합니다",
              style: TextStyle(
                color: AppColors.fontPrimary,
                fontSize: fontSizeManager.fontSize + 2, // 기본 크기 + 2
                fontWeight: FontWeight.bold,
              ),
            ),

            Spacer(),

            // 로그인 버튼
            FI_MainButton(
              text: "로그인",
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // 로그인 페이지로 이동
                      (route) => false, // 이전 스택 제거
                );
              },
              backgroundColor: AppColors.mainColor, // 버튼 색상
              textColor: Colors.white, // 텍스트 색상
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
