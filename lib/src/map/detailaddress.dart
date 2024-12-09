import 'package:flutter/material.dart';
import '../addmapmaker/detailed_location.dart';
import '../addmapmaker/detailed_location_detail_screen.dart';
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
  bool _isLiked = false;

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

  Future<void> _submitReview(Map<String, dynamic> newReview) async {
    try {
      final response = await ApiController.addReview(newReview);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _reviews.add(newReview);
          _reviewController.clear();
        });
      } else {
        print('Failed to add review');
      }
    } catch (e) {
      print('Error submitting review: $e');
    }
  }

  Future<void> _toggleLike(int reviewId) async {
    try {
      final response = await ApiController.toggleLike(reviewId);
      if (response.statusCode == 200) {
        setState(() {
          _isLiked = !_isLiked;
        });
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  void _viewDetailedLocation(DetailedLocation detailedLocation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedLocationDetailScreen(detailedLocation: detailedLocation),
      ),
    );
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
            // Facility Details
            Text(
              widget.facility.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Address: ${widget.facility.address}'),
            SizedBox(height: 10),
            Text('Description: ${widget.facility.description}'),
            SizedBox(height: 10),
            Text('Rating: ${widget.facility.rating}'),
            SizedBox(height: 10),
            Text('Type: ${widget.facility.type.name}'),
            SizedBox(height: 20),

            // Detailed Locations
            Text(
              '상세위치',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.facility.detailedLocations.length,
                itemBuilder: (context, index) {
                  DetailedLocation detailedLocation = widget.facility.detailedLocations[index];
                  return ListTile(
                    title: Text(detailedLocation.location),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rating: ${detailedLocation.rating}'),
                        Text('Latitude: ${detailedLocation.latitude}'),
                        Text('Longitude: ${detailedLocation.longitude}'),
                      ],
                    ),
                    onTap: () => _viewDetailedLocation(detailedLocation),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            // Reviews Section
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
                if (newReview != null) {
                  _submitReview(newReview);
                }
              },
              decoration: InputDecoration(
                hintText: '리뷰 작성 또는 수정하기',
                border: OutlineInputBorder(),
              ),
            ),
            Divider(),
            Expanded(
              child: _reviews.isEmpty
                  ? Center(child: Text('리뷰가 없습니다.'))
                  : ListView.builder(
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return ListTile(
                    leading: CircleAvatar(),
                    title: Text(review['username'] ?? 'Unknown'),
                    subtitle: Text(review['content']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(review['date']),
                        IconButton(
                          icon: Icon(_isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt),
                          onPressed: () => _toggleLike(review['id']),
                        ),
                      ],
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
