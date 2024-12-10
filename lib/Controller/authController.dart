import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:facilities_info/Controller/apiController.dart';

import 'package:facilities_info/models/user.dart';


class AuthController {
  static const String baseUrl = '${ApiController.apiUrl}/auth';

  // 이메일 인증 요청
  static Future<String> requestEmailVerification(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/emailVerify/$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return "Verification email sent successfully";
    } else if (response.statusCode == 500) {
      final message = jsonDecode(response.body)['message'];
      return message ?? "Failed to send verification email.";
    } else {
      throw Exception("이메일 인증 요청 중 오류 발생: ${response.statusCode}");
    }
  }

  // 이메일 인증 확인
  static Future<String> checkEmailVerification(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/checkEmailVerify/$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return "Email is verified and token deleted";
    } else if (response.statusCode == 400) {
      return "Email is not verified";
    } else {
      final message = jsonDecode(response.body)['message'];
      return message ?? "Unexpected error occurred.";
    }
  }

  static Future<dynamic> checkEmail(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/checkEmail/$email'));

    if (response.statusCode == 200) {
      // 사용 가능한 이메일
      return "Available email";
    } else if (response.statusCode == 409) {
      // 이미 사용 중인 이메일
      return "Email already in use";
    } else {
      // 그 외의 에러 처리
      throw Exception("이메일 확인 중 오류 발생: ${response.statusCode}");
    }
  }

  static Future<String> checkNickname(String nickname) async {
    final response = await http.get(Uri.parse('$baseUrl/checkNickname/$nickname'));

    if (response.statusCode == 200) {
      // 사용 가능한 닉네임
      return "Available nickname";
    } else if (response.statusCode == 409) {
      // 이미 사용 중인 닉네임
      return "Nickname already in use";
    } else {
      // 그 외의 에러 처리
      throw Exception("이메일 확인 중 오류 발생: ${response.statusCode}");
    }
  }

  static Future<String> registerLocalUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup/local'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return "Register Finished";
    } else {
      // 그 외의 에러 처리
      throw Exception("회원 가입 중 오류 발생: ${response.statusCode}");
    }
  }

  static Future<String> registerOAuthUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup/oauth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    return response.body;
  }

  static Future<dynamic> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/local/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(utf8.decode(response.bodyBytes))
    };
  }


  static Future<String> logoutUser(String accessToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    return response.body;
  }

}
