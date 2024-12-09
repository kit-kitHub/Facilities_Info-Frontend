import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'api_controller.dart';

class   FacilityReviewEditScreen extends StatefulWidget {
  @override
  _FacilityReviewEditScreenState createState() =>
      _FacilityReviewEditScreenState();
}

class _FacilityReviewEditScreenState extends State<FacilityReviewEditScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0; // 선택된 별점 수
  bool _isLiked = false;

  void _addReview(BuildContext context, int facilityId) async {
    final reviewData = {
      'facilityId': facilityId,
      'reviewComment': _commentController.text,
      'rating': _selectedRating,
    };
    final response = await ApiController.addReview(reviewData);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Review added successfully')));
      Navigator.popAndPushNamed(context, '/detail', arguments: facilityId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add review')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final int facilityId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: '댓글',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // 별점 선택 부분
            Text(
              '좋아요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                    color: _isLiked ? Colors.blue : Colors.grey,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _isLiked = !_isLiked; // 좋아요 상태 토글
                    });
                  },
                ),
                Text(
                  _isLiked ? '좋아요를 눌렀습니다' : '좋아요를 눌러보세요',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                if (_selectedRating == 0 || _commentController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('좋아요와 댓글을 입력해주세요.')),
                  );
                  return;
                }
                _addReview(context, facilityId);
                Navigator.pop(context);
              },
              child: Text('리뷰 제출'),
            ),
          ],
        ),
      ),
    );
  }
}
