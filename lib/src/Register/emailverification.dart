import 'package:flutter/material.dart';
import '/SingleTone/fontSizeManager.dart';
import 'EmailSentPage.dart';
import 'package:http/http.dart' as http;

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPage createState() => _EmailVerificationPage();
}

class _EmailVerificationPage extends State<EmailVerificationPage> {
  final TextEditingController emailController = TextEditingController();
  String emailMessage = '';
  final fontSizeManager = FontSizeManager();

  Future<void> _checkEmail() async {
    final response = await http.get(Uri.parse('http://3.34.105.70:8080/api/auth/checkEmail/${emailController.text}'));
    setState(() {
      if (response.statusCode == 200) {
        emailMessage = '사용 가능한 이메일입니다.';
      } else if (response.statusCode == 409) {
        emailMessage = '이미 사용 중인 이메일입니다.';
      } else {
        emailMessage = '오류가 발생했습니다.';
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
                style: TextStyle(fontSize: fontSizeManager.fontSize),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    await _checkEmail();
                    if (emailMessage == '사용 가능한 이메일입니다.') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmailSentPage(email: email),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('유효한 이메일을 입력하세요.', style: TextStyle(fontSize: fontSizeManager.fontSize),)),
                      );
                    }
                  },
                  child: Text('계속하기', style: TextStyle(fontSize: fontSizeManager.fontSize),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
