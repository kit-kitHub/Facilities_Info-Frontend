import 'package:flutter/material.dart';
import 'DuplicateCheckPage.dart';

class EmailSentPage extends StatelessWidget {
  final String email;

  EmailSentPage({required this.email});

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
                readOnly: true, // 읽기 전용 설정
                decoration: InputDecoration(
                  labelText: email, // email 변수를 라벨로 사용
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              Text(
                '이메일 인증 완료 후 아래 버튼을 눌러 계속해 주세요.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DuplicateCheckPage(
                          email: email,
                          errorMessage: '이미 존재하는 이메일입니다.',
                        ),
                      ),
                    );
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
