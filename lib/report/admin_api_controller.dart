import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiController {
  static const String baseUrl = 'http://3.34.105.70:8080';
  static const String _accessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJGYWNpbGl0aWVzLW1hcC1zZXJ2aWNlIiwiaWF0IjoxNzMzMzE1MzIyLCJleHAiOjE3MzM0MDE3MjIsInN1YiI6InF3ZUBxd2UiLCJpZCI6Mywic25zSWRPckVtYWlsIjoicXdlQHF3ZSIsInByb3ZpZGVyIjoibG9jYWwifQ.fWYkLhjVzk_Yd64KE0BX5GEmeD7LuKVeiTA04pkhzd4';

  Future<Map<String, dynamic>> blockUser(int userId) async {
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
