import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'api_controller.dart';

class FacilityReviewEditScreen extends StatefulWidget {
  @override
  _FacilityReviewEditScreenState createState() =>
      _FacilityReviewEditScreenState();
}

class _FacilityReviewEditScreenState extends State<FacilityReviewEditScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0; // 선택된 별점 수

  void _addReview(BuildContext context, int facilityId) async {
    final reviewData = {
      'facilityId': facilityId,
      'reviewComment': _commentController.text,
      'rating': _selectedRating,
    };
    try {
      final response = await ApiController.addReview(reviewData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Review added successfully')));
        Navigator.popAndPushNamed(context, '/detail', arguments: facilityId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add review: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')));
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
              '별점 선택',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _selectedRating = rating.toInt();
                });
              },
            ),

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                if (_commentController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('별점과 댓글을 입력해주세요.')),
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
