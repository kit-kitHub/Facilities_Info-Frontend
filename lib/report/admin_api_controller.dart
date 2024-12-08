import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiController {
  static const String baseUrl = 'http://3.34.105.70:8080';

  static Future<String?> _getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');  // Retrieve the stored access token
  }

  Future<Map<String, dynamic>> blockUser(int userId) async {
    String? _accessToken = await _getAccessToken();  // Fetch the token
    final response = await http.post(
      Uri.parse('$baseUrl/api/admin/block/$userId'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to block user');
    }
  }

  Future<void> unblockUser(int userId) async {
    String? _accessToken = await _getAccessToken();  // Fetch the token
    final response = await http.post(
      Uri.parse('$baseUrl/api/admin/unblock/$userId'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to unblock user');
    }
  }

  Future<Map<String, dynamic>> getUserBlockRecord(int userId) async {
    String? _accessToken = await _getAccessToken();  // Fetch the token
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/user-block/$userId'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch block record');
    }
  }

  Future<List<dynamic>> getAllBlockRecords() async {
    String? _accessToken = await _getAccessToken();  // Fetch the token
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/blocks'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch block records');
    }
  }
}
