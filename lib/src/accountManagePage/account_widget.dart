import 'package:flutter/material.dart';

import '/SingleTone/authService.dart';
import '/SingleTone/fontSizeManager.dart';

import '/src/accountManagePage/memberLogin.dart';

class AccountWidget extends StatelessWidget {
  const AccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSizeManager = FontSizeManager();

    final authService = AuthServiceTest();
    final isLoggedIn = authService.isLoggedIn();

    // 로그인된 사용자 정보 가져오기
    final user = isLoggedIn ? authService.getCurrentUser() : null;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 항상 표시되는 아이콘과 "계정" 텍스트
          Row(
            children: [
              Icon(Icons.person_outline, size: fontSizeManager.fontSize + 6, color: Colors.black54,),
              SizedBox(width: 10),
              Text(
                '계정',
                style: TextStyle(fontSize: fontSizeManager.fontSize),
              ),
            ],
          ),
          SizedBox(height: 20),
          // 로그인 여부에 따른 프로필 표시
          isLoggedIn
              ? Row(
            children: [
              // 프로필 이미지 또는 기본 아이콘
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue, // 테두리 색상
                    width: 2.0, // 테두리 두께
                  ),
                ),
                child: user!['profileImageUrl'] == null ||
                    user['profileImageUrl']!.isEmpty
                    ? Icon(Icons.person_outlined,
                    size: 40, color: Colors.grey[600])
                    : ClipOval(
                  child: Image.network(
                    user['profileImageUrl']!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20),
              // 닉네임과 이메일
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['nickname'] ?? '닉네임 없음',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    user['email'] ?? '이메일 없음',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          )
              : Center(
            child:  ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemberLogin()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                '로그인하기',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// AuthService 클래스 예제
// 실제 프로젝트에서는 자신의 인증 서비스 클래스를 사용하세요.
class AuthServiceTest {
  // 로그인 여부를 확인하는 메서드
  bool isLoggedIn() {
    // 실제 로그인 여부를 확인하는 로직으로 교체하세요.
    return false; // 테스트용으로 false 설정
  }

  // 현재 로그인된 사용자 정보를 반환하는 메서드
  Map<String, String?> getCurrentUser() {
    // 실제 사용자 정보를 반환하는 로직으로 교체하세요.
    return {
      'profileImageUrl': null,
      'nickname': '홍길동',
      'email': null,
    };
  }
}
