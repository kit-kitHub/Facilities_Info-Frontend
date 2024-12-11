import 'dart:convert';
import 'package:http/http.dart' as http;

import '../SingleTone/tokenManager.dart';

class ApiController {
  static const String baseUrl = 'http://3.34.105.70:8080';

  // 토큰을 가져오기 위해 TokenManager를 사용
  static Future<http.Response> createReport(String contentType, int contentId, Map<String, dynamic> reportData) async {
    final url = '$baseUrl/reports/$contentType/$contentId';

    // TokenManager를 사용하여 액세스 토큰 가져오기
    String? accessToken = await TokenManager().accessToken;

    if (accessToken == null) {
      throw Exception('Access token is not available');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken", // 가져온 토큰 사용
        "Content-Type": "application/json",
      },
      body: jsonEncode(reportData),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}'); // 응답 본문 출력
    return response;
  }

  static Future<List<dynamic>> getReportsByUser(int userId) async {
    final url = '$baseUrl/reports/user/$userId';

    String? accessToken = await TokenManager().accessToken;

    if (accessToken == null) {
      throw Exception('Access token is not available');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load reports');
    }
  }

  static Future<List<dynamic>> getAllReports() async {
    final url = '$baseUrl/reports';

    String? accessToken = await TokenManager().accessToken;

    if (accessToken == null) {
      throw Exception('Access token is not available');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load reports');
    }
  }
}
