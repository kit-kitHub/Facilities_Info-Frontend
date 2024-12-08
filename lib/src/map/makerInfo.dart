import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // intl 패키지 import
import 'package:shared_preferences/shared_preferences.dart'; // 로그인 상태 저장 예시
import 'package:facilities_info/screens/login_screen.dart'; // 로그인 화면으로 이동할 때 사용 (예시)

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

  bool _isLoggedIn = false; // 로그인 여부 상태

  void _fetchReviews() {
    setState(() {
      _reviews = [
        {'username': '사용자 이름1', 'review': '리뷰 내용1', 'date': '2024/11/06'},
        {'username': '사용자 이름2', 'review': '리뷰 내용2', 'date': '2024/11/07'},
      ];
    });
  }
  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
    _fetchReviews();
    _checkLoginStatus(); // 로그인 상태 확인
  }

  Future<void> _checkLoginStatus() async {
    // SharedPreferences를 사용하여 로그인 상태 확인
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // 로그인 여부 체크
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _currentRating += _isLiked ? 1 : -1;
    });
  }

  void _submitReview() {
    if (!_isLoggedIn) {
      _navigateToLogin();
      return;
    }

    if (_reviewController.text.isNotEmpty) {
      String formattedDate = DateFormat('yyyy/MM/dd').format(DateTime.now());

      final newReview = {
        'username': '사용자 이름3', // 사용자 이름 (예시)
        'review': _reviewController.text,
        'date': formattedDate,
      };

      setState(() {
        _reviews.add(newReview);
      });

      _reviewController.clear();
    }
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // 로그인 화면으로 이동
    );
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  widget.address,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 16),
                Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16),
                Text(widget.description, style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      _currentRating.toString(),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Icon(
                        _isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                        color: _isLiked ? Colors.blue : Colors.grey,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('리뷰 ${_reviews.length}개'),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _reviewController,
                  decoration: InputDecoration(
                    labelText: '리뷰 작성하기',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitReview,
                  child: Text('리뷰 제출하기'),
                ),
                SizedBox(height: 16),
                Divider(),
                if (_reviews.isNotEmpty)
                  ..._reviews.map(
                        (review) => ListTile(
                      leading: CircleAvatar(),
                      title: Text(review['username']!),
                      subtitle: Text(review['review']!),
                      trailing: Text(review['date']!),
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
