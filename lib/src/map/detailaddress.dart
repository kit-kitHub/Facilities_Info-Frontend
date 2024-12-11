import 'package:flutter/material.dart';
import '../addmapmaker/detailed_location.dart';
import '../addmapmaker/facility.dart';
import '../addmapmaker/facility_controller.dart';
import '/review/api_controller.dart';
import '/review/facility_review_edit_screen.dart';
import '/report/report_screen.dart';  // ReportScreen import 추가

class FacilityDetailScreen extends StatefulWidget {
  final Facility facility;

  FacilityDetailScreen({required this.facility});

  @override
  _FacilityDetailScreenState createState() => _FacilityDetailScreenState();
}

class _FacilityDetailScreenState extends State<FacilityDetailScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> _reviews = [];
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      final facilityData = await ApiController.getFacilityWithReviews(widget.facility.id);
      setState(() {
        _reviews = List<Map<String, dynamic>>.from(facilityData['reviews']);
      });
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.facility.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text('주소: ${widget.facility.address}'),
            SizedBox(height: 10),
            Text('설명: ${widget.facility.description}'),
            SizedBox(height: 10),
            Text('좋아요: ${widget.facility.rating.toInt()}'),
            SizedBox(height: 10),
            Text('유형: ${widget.facility.type.koreanName}'),
            SizedBox(height: 20),

            // Detailed Locations
            if (widget.facility.detailedLocations.isNotEmpty) ...[
              Text(
                '상세 위치',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 250), // 최대 높이 제한
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.facility.detailedLocations.length.clamp(0, 5),
                  itemBuilder: (context, index) {
                    DetailedLocation detailedLocation =
                    widget.facility.detailedLocations[index];
                    return ListTile(
                      leading: detailedLocation.images.isNotEmpty
                          ? Image.network(
                        detailedLocation.images.first,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.image_not_supported), // 이미지가 없을 경우 기본 아이콘 표시
                      title: Text(detailedLocation.location),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('좋아요: ${detailedLocation.rating.toInt()}'),
                          Text('위도: ${detailedLocation.latitude}'),
                          Text('경도: ${detailedLocation.longitude}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],

            // Reviews Section
            Text(
              '리뷰',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // '리뷰 추가하기' 버튼을 항상 표시
            ElevatedButton(
              onPressed: () async {
                final newReview = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacilityReviewEditScreen(),
                    settings: RouteSettings(arguments: widget.facility.id),
                  ),
                );
                if (newReview != null) {
                  _fetchReviews();  // 리뷰 추가 후 재조회
                }
              },
              child: Text('리뷰 추가하기'),
            ),
            SizedBox(height: 10),

            // 리뷰 리스트 표시
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 250), // 최대 높이 제한
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _reviews.length.clamp(0, 5),
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return ListTile(
                    leading: CircleAvatar(),
                    title: Text(review['user']['nickname'] ?? 'Unknown'),
                    subtitle: Text(review['reviewComment'] ?? ''),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.notifications_active,  // 사이렌 아이콘
                        color: Colors.red,  // 빨간색 아이콘
                      ),
                      onPressed: () {
                        // 신고하기 화면으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportScreen(
                              reviewId: review['id'],  // 리뷰 ID 전달
                              contentType: 'review',   // 컨텐츠 타입 전달
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
