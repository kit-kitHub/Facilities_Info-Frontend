import 'package:flutter/material.dart';
import 'package:facilities_info/src/Register/register.dart';
import 'package:http/http.dart' as http;

import '/SingleTone/fontSizeManager.dart';


class DuplicateCheckPage extends StatefulWidget {
  final String email;
  final String errorMessage;

  DuplicateCheckPage({required this.email, required this.errorMessage});

  @override
  _DuplicateCheckPage createState() => _DuplicateCheckPage();
}

class _DuplicateCheckPage extends State<DuplicateCheckPage> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final fontSizeManager = FontSizeManager();

  String nickname = '';

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

  Future<void> _checkNickname() async {
    final response = await http.get(
      Uri.parse('http://3.34.105.70:8080/api/auth/checkNickname/${nicknameController.text.trim()}'),
    );
    setState(() {
      if (response.statusCode == 200) {
        nickname = '사용 가능한 닉네임입니다.';
      } else if (response.statusCode == 409) {
        nickname = '이미 사용 중인 닉네임입니다.';
      } else {
        nickname = '오류가 발생했습니다.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', style: TextStyle(fontSize: fontSizeManager.fontSize),),
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
                readOnly: true,
                decoration: InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: nicknameController,
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
                  onPressed: () async {
                    if (nicknameController.text.trim().isNotEmpty) {
                      await _checkNickname();
                      if (nickname == '사용 가능한 닉네임입니다.') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompleteRegistrationPage(
                              email: widget.email,
                              nickname: nicknameController.text.trim(),
                            ),
                          ),
                        );
                      }
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
