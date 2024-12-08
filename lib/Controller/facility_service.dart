import 'dart:convert';
import 'package:http/http.dart' as http;

class Facility {
  final String name;
  final String address;
  final String description;
  final String imageUrl;
  final double rating;
  final String type;

  Facility({
    required this.name,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.type,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      name: json['name'] ?? 'No name',             // Null 방지
      address: json['address'] ?? 'No address',     // Null 방지
      description: json['description'] ?? '',      // 기본값 할당
      imageUrl: json['imageUrl'] ?? '',            // 기본값 할당
      rating: (json['rating'] ?? 0).toDouble(),    // 숫자 변환 및 기본값
      type: json['type'] ?? 'Unknown',             // Null 방지
    );
  }
}

Future<List<Facility>> searchFacilities({String? name, String? type}) async {
  final queryParameters = {
    if (name != null) 'name': name,
    if (type != null) 'type': type,
  };

  final uri = Uri.http('3.34.105.70:8080', 'api/facilities/search', queryParameters);

  final response = await http.get(uri, headers: {'Content-Type': 'application/json; charset=UTF-8'});

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
    return body.map((dynamic item) => Facility.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load facilities');
  }

}
