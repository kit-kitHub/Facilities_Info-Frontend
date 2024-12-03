import 'package:flutter/material.dart';
import 'EmailSentPage.dart';

class EmailVerificationPage extends StatelessWidget {
  // 이메일 입력을 위한 TextEditingController 추가
  final TextEditingController emailController = TextEditingController();

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
              TextFormField(
                controller: emailController, // 이메일 입력값을 이 컨트롤러에 저장
                decoration: InputDecoration(
                  labelText: '이메일',
                  hintText: '이메일을 입력하세요',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24),
              Text(
                '회원가입을 위해 이메일 인증이 필요합니다. 아래 버튼을 눌러 확인을 완료해 주세요.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 입력된 이메일 값을 가져옴
                    String email = emailController.text.trim();

                    if (email.isNotEmpty && email.contains('@')) {
                      // 다음 페이지로 이메일 값을 전달
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmailSentPage(email: email), // 전달
                        ),
                      );
                    } else {
                      // 이메일 유효성 검사 실패 시 메시지 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('유효한 이메일을 입력하세요.')),
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
