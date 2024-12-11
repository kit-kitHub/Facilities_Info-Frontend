import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../SingleTone/tokenManager.dart';

class ApiController {
  static const String baseUrl = 'http://3.34.105.70:8080/api';

  // Facility 정보를 가져오는 메서드
  static Future<Map<String, dynamic>> getFacilityWithReviews(int facilityId) async {
    final url = '$baseUrl/facility/$facilityId';
    final token = await TokenManager().accessToken; // AccessToken 동적으로 가져오기

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load facility');
    }
  }

  // Facility 업데이트 메서드 (이미지 포함)
  static Future<http.Response> updateFacilityWithImages(
      int facilityId, String name, String address, String description, List<File> images) async {
    final url = '$baseUrl/update/facility/info/$facilityId';
    final token = await TokenManager().accessToken; // AccessToken 동적으로 가져오기

    final request = http.MultipartRequest('PUT', Uri.parse(url));

    request.fields['name'] = name;
    request.fields['address'] = address;
    request.fields['description'] = description;

    for (var image in images) {
      request.files.add(await http.MultipartFile.fromPath('images', image.path));
    }

    request.headers['Authorization'] = 'Bearer $token';

    return await http.Response.fromStream(await request.send());
  }

  // 리뷰 추가 메서드
  static Future<http.Response> addReview(Map<String, dynamic> reviewData) async {
    final url = '$baseUrl/review/add';
    final token = await TokenManager().accessToken; // AccessToken 동적으로 가져오기

    return await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(reviewData),
    );
  }

  // 리뷰 삭제 메서드
  static Future<http.Response> deleteReview(int reviewId) async {
    final url = '$baseUrl/review/delete/$reviewId';
    final token = await TokenManager().accessToken; // AccessToken 동적으로 가져오기

    return await http.delete(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  // 리뷰 업데이트 메서드
  static Future<http.Response> updateReview(int reviewId, Map<String, dynamic> reviewData) async {
    final url = '$baseUrl/review/update/$reviewId';
    final token = await TokenManager().accessToken; // AccessToken 동적으로 가져오기

    return await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(reviewData),
    );
  }

  // 좋아요 토글 메서드
  static Future<http.Response> toggleLike(int reviewId) async {
    final url = '$baseUrl/review/$reviewId/like';
    final token = await TokenManager().accessToken; // AccessToken 동적으로 가져오기

    return await http.put(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}
