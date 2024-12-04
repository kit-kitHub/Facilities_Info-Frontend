import 'package:flutter/material.dart';
import '../../review/api_controller.dart';
import '../../review/facility_review_edit_screen.dart'; // ApiController 사용

class DraggableSheet extends StatefulWidget {
  final ScrollController scrollController;
  final String title;
  final String address;
  final String imageUrl;
  final String description;
  final int rating;
  final int facilityId;

  DraggableSheet({
    required this.scrollController,
    required this.title,
    required this.address,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.facilityId,
  });

  @override
  _DraggableSheetState createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  bool _isLiked = false;
  late int _currentRating;
  List<Map<String, dynamic>> _reviews = [];
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
    _fetchFacilityAndReviews();
  }

  Future<void> _fetchFacilityAndReviews() async {
    try {
      final facilityData = await ApiController.getFacilityWithReviews(widget.facilityId);
      setState(() {
        _reviews = List<Map<String, dynamic>>.from(facilityData['reviews']);
      });
    } catch (e) {
      print('Error fetching facility and reviews: $e');
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: ListView(
        controller: widget.scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(widget.address, style: TextStyle(color: Colors.grey[700])),
                SizedBox(height: 16),
                Image.network(widget.imageUrl, fit: BoxFit.cover),
                SizedBox(height: 16),
                Text(widget.description, style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),

                // 별점 표시 부분
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < _currentRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    );
                  }),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _reviewController,
                  readOnly: true,
                  onTap: () async {
                    final newReview = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FacilityReviewEditScreen(),
                        settings: RouteSettings(arguments: widget.facilityId),
                      ),
                    );

                    if (newReview != null) {
                      _submitReview(newReview); // 새로운 리뷰 저장
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '리뷰 작성 또는 수정하기',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Divider(),
                if (_reviews.isNotEmpty)
                  ..._reviews.map((review) {
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
                  }).toList(),
                if (_reviews.isEmpty)
                  Center(child: Text('리뷰가 없습니다.')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
