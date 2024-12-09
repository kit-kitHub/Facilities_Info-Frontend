class FacilityGeoCoordinates {
  final double latitude;
  final double longitude;

  FacilityGeoCoordinates({required this.latitude, required this.longitude});

  factory FacilityGeoCoordinates.fromJson(Map<String, dynamic> json) {
    return FacilityGeoCoordinates(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
