import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ApiController {
  static const String baseUrl = 'http://192.168.0.6:8080/api';

  // SharedPreferences에서 accessToken 가져오기
  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  static Future<Map<String, dynamic>> getFacilityWithReviews(int facilityId) async {
    final accessToken = await _getAccessToken();
    final url = '$baseUrl/facility/$facilityId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load facility');
    }
  }

  static Future<http.Response> updateFacilityWithImages(
      int facilityId, String name, String address, String description, List<File> images) async {
    final accessToken = await _getAccessToken();
    final url = '$baseUrl/update/facility/info/$facilityId';
    final request = http.MultipartRequest('PUT', Uri.parse(url));

    request.fields['name'] = name;
    request.fields['address'] = address;
    request.fields['description'] = description;

    for (var image in images) {
      request.files.add(await http.MultipartFile.fromPath('images', image.path));
    }

    request.headers['Authorization'] = 'Bearer $accessToken';

    return await http.Response.fromStream(await request.send());
  }

  static Future<http.Response> addReview(Map<String, dynamic> reviewData) async {
    final accessToken = await _getAccessToken();
    final url = '$baseUrl/review/add';
    return await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(reviewData),
    );
  }

  static Future<http.Response> deleteReview(int reviewId) async {
    final accessToken = await _getAccessToken();
    final url = '$baseUrl/review/delete/$reviewId';
    return await http.delete(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  static Future<http.Response> updateReview(int reviewId, Map<String, dynamic> reviewData) async {
    final accessToken = await _getAccessToken();
    final url = '$baseUrl/review/update/$reviewId';
    return await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(reviewData),
    );
  }

  static Future<http.Response> toggleLike(int reviewId) async {
    final accessToken = await _getAccessToken();
    final url = '$baseUrl/review/$reviewId/like';
    return await http.put(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );
  }
}
