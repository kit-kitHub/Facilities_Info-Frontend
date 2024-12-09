import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'facility.dart';

class ApiService {
  static const String baseUrl = 'http://3.34.105.70:8080/api';

  Future<List<Facility>> searchFacilities({String? name, FacilityType? type}) async {
    final Map<String, String> queryParameters = {};

    if (name != null) {
      queryParameters['name'] = name;
    }
    if (type != null) {
      queryParameters['type'] = type.name;
    }

    final uri = Uri.parse('$baseUrl/facilities/search').replace(queryParameters: queryParameters);
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json; charset=utf-8',
    });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((facility) => Facility.fromJson(facility)).toList();
    } else {
      throw Exception('Failed to load facilities');
    }
  }

  Future<Facility> getFacilityById(int facilityId) async {
    final response = await http.get(Uri.parse('$baseUrl/facility/$facilityId'), headers: {
      'Content-Type': 'application/json; charset=utf-8',
    });

    if (response.statusCode == 200) {
      return Facility.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load facility');
    }
  }

  Future<void> createFacility(Map<String, dynamic> facilityData, List<File> imageFiles) async {
    var request = MultipartRequest('POST', Uri.parse('$baseUrl/facility'));

    request.fields['name'] = facilityData['name'];
    request.fields['address'] = facilityData['address'];
    request.fields['description'] = facilityData['description'];
    request.fields['type'] = facilityData['type'];
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

  Future<void> deleteFacility(int facilityId) async {
    final response = await http.delete(Uri.parse('$baseUrl/facility/$facilityId'), headers: {
      'Content-Type': 'application/json; charset=utf-8',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to delete facility');
    }
  }

  Future<void> createDetailedLocation(Map<String, dynamic> detailedLocationData, List<File> imageFiles) async {
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

  Future<void> deleteDetailedLocation(int detailedLocationId) async {
    final response = await http.delete(Uri.parse('$baseUrl/detailed-locations/$detailedLocationId'), headers: {
      'Content-Type': 'application/json; charset=utf-8',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to delete detailed location');
    }
  }
}
