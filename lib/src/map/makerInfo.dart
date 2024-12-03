import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // intl 패키지 import

//마커의 정보가 보여지는 칸
class DraggableSheet extends StatefulWidget {
  final ScrollController scrollController;

  final String title;
  final String address;
  final String imageUrl;
  final String description;
  final int rating; // rating을 int로 변경

  DraggableSheet({
    required this.scrollController,
    required this.title,
    required this.address,
    required this.imageUrl,
    required this.description,
    required this.rating,
  });

  @override
  _DraggableSheetState createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  bool _isLiked = false; // 좋아요 상태
  late int _currentRating;
  List<Map<String, String>> _reviews = []; // 리뷰 리스트
  final TextEditingController _reviewController = TextEditingController(); // 리뷰 작성 컨트롤러

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating; // 초기 rating 값을 설정
    _fetchReviews(); // 데이터베이스에서 리뷰 데이터 가져오기
  }

  // 임시로 리뷰 데이터를 받아오는 함수 (실제 데이터베이스 연동 시 변경)
  void _fetchReviews() {
    // 예시 데이터 (실제 데이터베이스에서 받아오면 됩니다)
    setState(() {
      _reviews = [
        {'username': '사용자 이름1', 'review': '리뷰 내용1', 'date': '2024/11/06'},
        {'username': '사용자 이름2', 'review': '리뷰 내용2', 'date': '2024/11/07'},
      ];
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked; // 좋아요 상태 토글
      if (_isLiked) {
        _currentRating += 1; // 좋아요가 눌리면 rating 1 증가
      } else {
        _currentRating -= 1; // 좋아요가 취소되면 rating 1 감소
      }
    });
  }

  // 리뷰 제출 함수
  void _submitReview() {
    if (_reviewController.text.isNotEmpty) {
      // 현재 시간을 년/월/일 형식으로 포맷
      String formattedDate = DateFormat('yyyy/MM/dd').format(DateTime.now());

      final newReview = {
        'username': '사용자 이름3', // 사용자 이름 (예시)
        'review': _reviewController.text, // 사용자가 입력한 리뷰 내용
        'date': formattedDate, // 포맷된 현재 시간으로 작성일 설정
      };

      setState(() {
        _reviews.add(newReview); // 새로운 리뷰를 리스트에 추가
      });

      _reviewController.clear(); // 리뷰 텍스트 필드 초기화
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: ListView(
        controller: widget.scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.address,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 16),
                Image.network(
                  widget.imageUrl, // 이미지 URL
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16),
                Text(
                  widget.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      _currentRating.toString(), // 업데이트된 rating 값을 표시
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: _toggleLike, // 버튼 클릭 시 상태 변경
                      child: Icon(
                        _isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt, // 좋아요 상태에 따라 아이콘 변경
                        color: _isLiked ? Colors.blue : Colors.grey, // 색상도 상태에 맞게 변경
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('리뷰 ${_reviews.length}개'), // 리뷰 개수를 동적으로 표시
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _reviewController, // 텍스트 필드에 컨트롤러 연결
                  decoration: InputDecoration(
                    labelText: '리뷰 작성하기',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitReview, // 리뷰 제출 버튼 클릭 시 리뷰 추가
                  child: Text('리뷰 제출하기'),
                ),
                SizedBox(height: 16),
                Divider(),
                // 리뷰가 있을 때만 ListTile 표시
                if (_reviews.isNotEmpty)
                  ..._reviews.map(
                        (review) => ListTile(
                      leading: CircleAvatar(),
                      title: Text(review['username']!),
                      subtitle: Text(review['review']!),
                      trailing: Text(review['date']!), // 작성일 표시
                    ),
                  ).toList(),
                if (_reviews.isEmpty)
                  Center(child: Text("리뷰가 없습니다.")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
