import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class ApiController {
  static const String baseUrl = 'http://3.34.105.70:8080/api';
  // Method to fetch the access token dynamically from SharedPreferences

  static Future<String?> _getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');  // Retrieve the stored access token
  }
  static Future<Map<String, dynamic>> getFacilityWithReviews(int facilityId) async {
    final url = '$baseUrl/facility/$facilityId';
    String? accessToken = await _getAccessToken();

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

  static Future<http.Response> updateFacilityWithImages(int facilityId, String name, String address, String description, List<File> images) async {
    final url = '$baseUrl/update/facility/info/$facilityId';
    String? accessToken = await _getAccessToken();
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
    final url = '$baseUrl/review/add';
    String? accessToken = await _getAccessToken();
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
    final url = '$baseUrl/review/delete/$reviewId';
    String? accessToken = await _getAccessToken();
    return await http.delete(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  static Future<http.Response> updateReview(int reviewId, Map<String, dynamic> reviewData) async {
    final url = '$baseUrl/review/update/$reviewId';
    String? accessToken = await _getAccessToken();
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
    final url = '$baseUrl/review/$reviewId/like';
    String? accessToken = await _getAccessToken();
    return await http.put(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );
  }
}
