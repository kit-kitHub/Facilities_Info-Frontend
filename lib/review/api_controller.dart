import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ApiController {
  static const String baseUrl = 'http://3.34.105.70:8080/api';
  static const String accessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJGYWNpbGl0aWVzLW1hcC1zZXJ2aWNlIiwiaWF0IjoxNzMzMjI3MDAyLCJleHAiOjE3MzMzMTM0MDIsInN1YiI6ImFzZEBhc2QiLCJpZCI6MSwic25zSWRPckVtYWlsIjoiYXNkQGFzZCIsInByb3ZpZGVyIjoibG9jYWwifQ.xhEYAMlW6vFII3dTM1TTdCynP-_eJvpIVipVi_7AzHI';

  static Future<Map<String, dynamic>> getFacilityWithReviews(int facilityId) async {
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

  static Future<http.Response> updateFacilityWithImages(int facilityId, String name, String address, String description, List<File> images) async {
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
    final url = '$baseUrl/review/delete/$reviewId';
    return await http.delete(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  static Future<http.Response> updateReview(int reviewId, Map<String, dynamic> reviewData) async {
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
    final url = '$baseUrl/review/$reviewId/like';
    return await http.put(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );
  }
}
