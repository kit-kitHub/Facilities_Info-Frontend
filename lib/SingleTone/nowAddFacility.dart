class NowAddFacility {
  // Singleton instance
  static final NowAddFacility _instance = NowAddFacility._internal();

  // Facility 정보를 저장할 변수
  String? name;
  String? address;
  double? latitude;
  double? longitude;
  int? locationId;
  String? locationName;
  String? locationDetail;
  String? facilityType;
  String? rating;
  String? description;
  String? imagePath;
  bool? newLocation;

  // 내부 생성자
  NowAddFacility._internal();

  // Singleton 인스턴스 반환
  factory NowAddFacility() {
    return _instance;
  }

  // 데이터 초기화
  void clear() {
    name = null;
    address = null;
    latitude = null;
    longitude = null;
    locationId = null;
    locationName = null;
    locationDetail = null;
    facilityType = null;
    rating = null;
    description = null;
    imagePath = null;
    newLocation = false;
  }

  @override
  String toString() {
    return 'NowAddFacility(name: $name, address: $address, description: $description)';
  }
}
