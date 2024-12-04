import 'dart:convert';
import 'package:http/http.dart' as http;

class Facility {
  final int id;
  final String name;
  final String address;
  final String description;
  final String imageUrl;
  final double rating;
  final String type;

  Facility({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.type,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'],
      name: json['name'] ?? 'No name',             // Null 방지
      address: json['address'] ?? 'No address',     // Null 방지
      description: json['description'] ?? '',      // 기본값 할당
      imageUrl: json['imageUrl'] ?? '',            // 기본값 할당
      rating: (json['rating'] ?? 0).toDouble(),    // 숫자 변환 및 기본값
      type: json['type'] ?? 'Unknown',             // Null 방지
    );
  }
}

class GeoCoordinates {
  final double latitude;
  final double longitude;
  final Facility facility;

  GeoCoordinates({required this.latitude, required this.longitude, required this.facility});

  factory GeoCoordinates.fromJson(Map<String, dynamic> json) {
    return GeoCoordinates(
      latitude: json['latitude'],
      longitude: json['longitude'],
      facility: Facility.fromJson(json['facility']),
    );
  }
}

Future<List<GeoCoordinates>> fetchGeoCoordinates(double latitude, double longitude, double radius) async {
  final uri = Uri.http('192.168.0.6:8080', 'api/geo-coordinates/within-radius', {
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
    'radius': radius.toString(),
  });

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
    return body.map((item) => GeoCoordinates.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load geo coordinates');
  }
}


Future<List<Facility>> searchFacilities({String? name}) async {
  final queryParameters = {
    if (name != null) 'name': name,
  };

  final uri = Uri.http('192.168.0.6:8080', 'api/facilities/search', queryParameters);

  final response = await http.get(uri, headers: {'Content-Type': 'application/json; charset=UTF-8'});

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
    return body.map((dynamic item) => Facility.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load facilities');
  }
}