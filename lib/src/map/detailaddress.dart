import 'package:flutter/material.dart';
import '../addmapmaker/detailed_location.dart';
import '../addmapmaker/facility.dart';
import '../addmapmaker/facility_controller.dart';
import '/review/api_controller.dart';
import '/review/facility_review_edit_screen.dart';

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
  Set<int> _likedLocations = {};
  Set<int> _dislikedLocations = {};
  Set<int> _likedReviews = {};

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

  Future<void> _toggleLikeLocation(int locationId) async {
    setState(() {
      if (_likedLocations.contains(locationId)) {
        _likedLocations.remove(locationId);
      } else {
        _likedLocations.add(locationId);
        _dislikedLocations.remove(locationId);
      }
    });
  }

  Future<void> _toggleDislikeLocation(int locationId) async {
    setState(() {
      if (_dislikedLocations.contains(locationId)) {
        _dislikedLocations.remove(locationId);
      } else {
        _dislikedLocations.add(locationId);
        _likedLocations.remove(locationId);
      }
    });
  }

  Future<void> _toggleLikeReview(int reviewId) async {
    setState(() {
      if (_likedReviews.contains(reviewId)) {
        _likedReviews.remove(reviewId);
      } else {
        _likedReviews.add(reviewId);
      }
    });
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _likedLocations.contains(detailedLocation.id)
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_off_alt,
                              color: _likedLocations.contains(detailedLocation.id)
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            onPressed: () => _toggleLikeLocation(detailedLocation.id),
                          ),
                          IconButton(
                            icon: Icon(
                              _dislikedLocations.contains(detailedLocation.id)
                                  ? Icons.thumb_down
                                  : Icons.thumb_down_off_alt,
                              color: _dislikedLocations.contains(detailedLocation.id)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () => _toggleDislikeLocation(detailedLocation.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],

            // Reviews Section
            if (_reviews.isNotEmpty) ...[
              Text(
                '리뷰',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _reviewController,
                readOnly: true,
                onTap: () async {
                  final newReview = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FacilityReviewEditScreen(),
                      settings: RouteSettings(arguments: widget.facility.id),
                    ),
                  );
                },
                decoration: InputDecoration(
                  hintText: '리뷰 작성 또는 수정하기',
                  border: OutlineInputBorder(),
                ),
              ),
              Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 250), // 최대 높이 제한
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _reviews.length.clamp(0, 5),
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    return ListTile(
                      leading: CircleAvatar(),
                      title: Text(review['username'] ?? 'Unknown'),
                      subtitle: Text(review['content']),
                      trailing: IconButton(
                        icon: Icon(
                          _likedReviews.contains(review['id'])
                              ? Icons.thumb_up
                              : Icons.thumb_up_off_alt,
                          color: _likedReviews.contains(review['id'])
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        onPressed: () => _toggleLikeReview(review['id']),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
