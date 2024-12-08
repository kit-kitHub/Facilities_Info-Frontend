import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiController {
  static const String baseUrl = 'http://3.34.105.70:8080';

  // Method to fetch the access token dynamically from SharedPreferences
  static Future<String?> _getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');  // Retrieve the stored access token
  }

  static Future<http.Response> createReport(String contentType, int contentId, Map<String, dynamic> reportData) async {
    final url = '$baseUrl/reports/$contentType/$contentId';
    String? accessToken = await _getAccessToken();  // Fetch the token

    if (accessToken == null) {
      throw Exception('Access token is not available');
    }

    return await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(reportData),
    );
  }

  static Future<List<dynamic>> getReportsByUser(int userId) async {
    final url = '$baseUrl/reports/user/$userId';
    String? accessToken = await _getAccessToken();  // Fetch the token

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
    String? accessToken = await _getAccessToken();  // Fetch the token

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
