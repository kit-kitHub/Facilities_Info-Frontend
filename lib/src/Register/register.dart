import 'package:flutter/material.dart';

import '../../screens/login_screen.dart';

class CompleteRegistrationPage extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordcheckController = TextEditingController();

  final String email;
  final String nickname;

  CompleteRegistrationPage({required this.email, required this.nickname});

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
                  labelText: email,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                readOnly: true, // 읽기 전용 설정
                decoration: InputDecoration(
                  labelText: nickname,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  hintText: '8-16자의 영문, 숫자, 특수기호',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: passwordcheckController, // 이메일 입력값을 이 컨트롤러에 저장
                decoration: InputDecoration(
                  labelText: '비밀번호 재입력',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String password = passwordController.text.trim();
                    String passwordcheck = passwordcheckController.text.trim();

                    if (password == passwordcheck) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('회원가입이 완료되었습니다!')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(), // 전달
                        ),
                      );
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('비밀번호를 다시 입력해 주세요')),
                      );
                    }
                  },
                  child: Text('회원가입 하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
