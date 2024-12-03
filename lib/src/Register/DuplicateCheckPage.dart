import 'package:flutter/material.dart';
import 'package:facilities_info/src/Register/register.dart';

class DuplicateCheckPage extends StatelessWidget {
  final TextEditingController nicknameController = TextEditingController();


  final String email;
  final String errorMessage;

  DuplicateCheckPage({required this.email, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              // 읽기 전용 이메일 필드
              TextFormField(
                initialValue: email, // 전달받은 이메일 값 표시
                readOnly: true, // 읽기 전용 설정
                decoration: InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              // 닉네임 입력 필드
              TextFormField(
                controller: nicknameController, // 이메일 입력값을 이 컨트롤러에 저장
                decoration: InputDecoration(
                  labelText: '닉네임',
                  hintText: '닉네임을 입력하세요',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String nickname = nicknameController.text.trim();

                    if (nickname.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompleteRegistrationPage(email: email, nickname: nickname), // 전달
                        ),
                      );
                    }
                  },
                  child: Text('계속하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
