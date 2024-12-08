import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  void _signup() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String nickname = _nicknameController.text;

    User user = User(email: email, password: password, nickname: nickname);
    String result = await ApiService.registerLocalUser(user);

    // Handle the result accordingly
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
            ),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            CustomTextField(
              controller: _nicknameController,
              hintText: 'Nickname',
            ),
            CustomButton(
              text: 'Sign Up',
              onPressed: _signup,
            ),
          ],
        ),
      ),
    );
  }
}
