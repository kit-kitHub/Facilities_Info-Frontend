import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:facilities_info/models/user.dart';


class AuthController {
  static const String baseUrl = 'http://3.34.105.70:8080/api/auth';

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
    final response = await http.get(Uri.parse('$baseUrl/checknickname/$nickname'));

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

    if (response.statusCode == 200) {
      // 로그인 성공, 토큰 반환
      return Map<String, String>.from(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      // 비밀번호가 일치하지 않는 경우
      return "Invalid password";
    } else if (response.statusCode == 404) {
      // email 또는 snsId가 없는 경우
      return "User not found";
    } else {
      // 그 외의 에러 처리
      throw Exception("로그인 중 오류 발생: ${response.statusCode}");
    }
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
