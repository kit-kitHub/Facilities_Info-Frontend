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
