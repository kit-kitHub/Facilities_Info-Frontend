import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:facilities_info/models/user.dart';


class AuthController {
  static const String baseUrl = 'http://3.34.105.70:8080/api/auth';

  static Future<String> checkEmail(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/checkEmail/$email'));
    return response.body;
  }

  static Future<String> checkNickname(String nickname) async {
    final response = await http.get(Uri.parse('$baseUrl/checknickname/$nickname'));
    return response.body;
  }

  static Future<String> registerLocalUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup/local'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    return response.body;
  }

  static Future<String> registerOAuthUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup/oauth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    return response.body;
  }

  static Future<Map<String, String>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/local/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return Map<String, String>.from(jsonDecode(response.body));
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
