import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';

import 'package:facilities_info/Controller/apiController.dart';
import 'package:facilities_info/models/facility.dart';

class FacilitiesController {
  static final String baseUrl = ApiController.apiHost; // 도메인 설정
  static final String apiPath = "api/facilities/search"; // API 경로

  static Future<List<Facility>> searchFacilities({String? name}) async {
    // 요청 URL 생성
    final uri = Uri.http(
      baseUrl, // 도메인과 포트 번호
      apiPath, // 경로
      {'name': name ?? ''}, // 쿼리 파라미터
    );

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        return body.map((dynamic item) => Facility.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        // 404 에러 발생 시 빈 리스트 반환
        return [];
      } else {
        throw Exception('Failed to load facilities, statusCode: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }


  static Future<void> createFacility(Map<String, dynamic> facilityData, List<File> imageFiles) async {
    var request = MultipartRequest('POST', Uri.parse('${ApiController.apiUrl}/facility'));

    request.fields['name'] = facilityData['name'];
    request.fields['address'] = facilityData['address'];
    // request.fields['description'] = facilityData['description'];
    // request.fields['type'] = facilityData['type'];
    request.fields['latitude'] = facilityData['latitude'].toString();
    request.fields['longitude'] = facilityData['longitude'].toString();

    // 이미지 파일 추가
    for (var file in imageFiles) {
      request.files.add(await MultipartFile.fromPath('images', file.path));
    }

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to create facility');
    }
  }


  static Future<void> createDetailedLocation(Map<String, dynamic> detailedLocationData, List<File> imageFiles) async {
    var request = MultipartRequest('POST', Uri.parse('$baseUrl/detailed-locations'));

    request.fields['location'] = detailedLocationData['location'];
    request.fields['rating'] = detailedLocationData['rating'].toString();
    request.fields['latitude'] = detailedLocationData['latitude'].toString();
    request.fields['longitude'] = detailedLocationData['longitude'].toString();
    request.fields['facilityId'] = detailedLocationData['facilityId'].toString();

    // 이미지 파일 추가
    for (var file in imageFiles) {
      request.files.add(await MultipartFile.fromPath('images', file.path));
    }

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to create detailed location');
    }
  }
}
