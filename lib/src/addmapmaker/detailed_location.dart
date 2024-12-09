class DetailedLocation {
  final int id;
  final String location;
  final double rating;
  final double latitude;
  final double longitude;
  final List<String> images;

  DetailedLocation({
    required this.id,
    required this.location,
    required this.rating,
    required this.latitude,
    required this.longitude,
    this.images = const [],
  });

  factory DetailedLocation.fromJson(Map<String, dynamic> json) {
    return DetailedLocation(
      id: json['id'],
      location: json['location'],
      rating: json['rating'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      images: json['images']?.cast<String>() ?? [],
    );
  }
}
