import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'EmailSentPage.dart';

class EmailVerificationPage extends StatelessWidget {
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
                controller: emailController,
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
                  onPressed: () async {
                    String email = emailController.text.trim();

                    if (email.isNotEmpty && email.contains('@')) {
                      // API 호출로 이메일 중복 검사
                      String response = await ApiService.checkEmail(email);

                      if (response == 'true') { // 중복 이메일인 경우
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('이미 사용 중인 이메일입니다. 다른 이메일을 입력하세요.')),
                        );
                      } else {
                        // 이메일이 사용 가능하면 다음 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailSentPage(email: email),
                          ),
                        );
                      }
                    } else {
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
