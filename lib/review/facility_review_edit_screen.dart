import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacilityReviewEditScreen extends StatefulWidget {
  @override
  _FacilityReviewEditScreenState createState() =>
      _FacilityReviewEditScreenState();
}

class _FacilityReviewEditScreenState extends State<FacilityReviewEditScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0; // 선택된 별점 수

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
            Text('별점',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRating = index + 1; // 별점은 1부터 시작
                    });
                  },
                  child: Icon(
                    index < _selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                );
              }),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                if (_selectedRating == 0 || _commentController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('별점과 댓글을 입력해주세요.')),
                  );
                  return;
                }

                final reviewData = {
                  'facilityId': facilityId,
                  'content': _commentController.text,
                  'rating': _selectedRating,
                  'date': DateFormat('yyyy/MM/dd').format(DateTime.now()),
                  // 날짜 추가
                };

                Navigator.pop(context, reviewData); // 리뷰 데이터를 반환
              },
              child: Text('리뷰 제출'),
            ),
          ],
        ),
      ),
    );
  }
}
