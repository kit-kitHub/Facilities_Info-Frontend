import 'dart:convert';
import 'package:http/http.dart' as http;
import '../SingleTone/tokenManager.dart';  // TokenManager import 추가

class ApiController {
  static const String baseUrl = 'http://3.34.105.70:8080';

  // User 차단 메서드
  Future<Map<String, dynamic>> blockUser(int userId) async {
    final token = await TokenManager().accessToken; // TokenManager에서 액세스 토큰 가져오기

    if (token == null) {
      throw Exception('Access token is not available');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/admin/block/$userId'),
      headers: {
        'Authorization': 'Bearer $token', // 동적으로 가져온 토큰 사용
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to block user');
    }
  }

  // User 차단 해제 메서드
  Future<void> unblockUser(int userId) async {
    final token = await TokenManager().accessToken; // TokenManager에서 액세스 토큰 가져오기

    if (token == null) {
      throw Exception('Access token is not available');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/admin/unblock/$userId'),
      headers: {
        'Authorization': 'Bearer $token', // 동적으로 가져온 토큰 사용
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unblock user');
    }
  }

  // User 차단 기록 조회 메서드
  Future<Map<String, dynamic>> getUserBlockRecord(int userId) async {
    final token = await TokenManager().accessToken; // TokenManager에서 액세스 토큰 가져오기

    if (token == null) {
      throw Exception('Access token is not available');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/user-block/$userId'),
      headers: {
        'Authorization': 'Bearer $token', // 동적으로 가져온 토큰 사용
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch block record');
    }
  }

  // 모든 차단 기록 조회 메서드
  Future<List<dynamic>> getAllBlockRecords() async {
    final token = await TokenManager().accessToken; // TokenManager에서 액세스 토큰 가져오기

    if (token == null) {
      throw Exception('Access token is not available');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/blocks'),
      headers: {
        'Authorization': 'Bearer $token', // 동적으로 가져온 토큰 사용
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch block records');
    }
  }
}
