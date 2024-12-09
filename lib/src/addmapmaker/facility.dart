import 'detailed_location.dart';

class Facility {
  final int id;
  final String name;
  final String address;
  final String description;
  final double rating;
  final FacilityType type;
  final List<DetailedLocation> detailedLocations;

  Facility({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.rating,
    required this.type,
    this.detailedLocations = const [],
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      description: json['description'],
      rating: json['rating'],
      type: FacilityTypeExtension.fromName(json['type']),
      detailedLocations: (json['detailedLocations'] as List<dynamic>?)
          ?.map((e) => DetailedLocation.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

enum FacilityType {
  PARKING_LOT,
  WELFARE_CENTER,
  MEDICAL_FACILITY,
  RESTROOM,
}

extension FacilityTypeExtension on FacilityType {
  static FacilityType fromName(String name) {
    switch (name) {
      case 'PARKING_LOT':
        return FacilityType.PARKING_LOT;
      case 'WELFARE_CENTER':
        return FacilityType.WELFARE_CENTER;
      case 'MEDICAL_FACILITY':
        return FacilityType.MEDICAL_FACILITY;
      case 'RESTROOM':
        return FacilityType.RESTROOM;
      default:
        throw Exception('Unknown FacilityType: $name');
    }
  }

  String get name {
    switch (this) {
      case FacilityType.PARKING_LOT:
        return 'PARKING_LOT';
      case FacilityType.WELFARE_CENTER:
        return 'WELFARE_CENTER';
      case FacilityType.MEDICAL_FACILITY:
        return 'MEDICAL_FACILITY';
      case FacilityType.RESTROOM:
        return 'RESTROOM';
      default:
        return '';
    }
  }
}
