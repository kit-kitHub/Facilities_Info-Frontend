import 'dart:convert';
import 'package:http/http.dart' as http;

import '/SingleTone/authService.dart';


class AuthLocalController {
  // 서버 URL
  final String baseUrl;

  AuthLocalController(this.baseUrl);

  // 로그인 요청
  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final accessToken = responseData['access_token'];
      final refreshToken = responseData['refresh_token'];

      if (accessToken != null && refreshToken != null) {
        // AuthService를 사용하여 토큰 저장
        await AuthService().login(accessToken, refreshToken);
      } else {
        throw Exception('Invalid token received from server');
      }
    } else if (response.statusCode == 404) {
      // email이 없는 경우
      throw Exception('User not found');
    } else if (response.statusCode == 401) {
      // 비밀번호 불일치
      throw Exception('Invalid password');
    } else {
      // 기타 오류
      final errorMessage = jsonDecode(response.body)['message'] ?? 'Login failed';
      throw Exception(errorMessage);
    }
  }
}
