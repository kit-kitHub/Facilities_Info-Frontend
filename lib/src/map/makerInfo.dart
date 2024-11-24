import 'package:flutter/material.dart';

//마커의 정보가 보여지는 칸
class DraggableSheet extends StatelessWidget {
  final ScrollController scrollController;

  final String title;
  final String address;
  final String imageUrl;
  final String description;
  final String rating;

  DraggableSheet({
    required this.scrollController,
    required this.title,
    required this.address,
    required this.imageUrl,
    required this.description,
    required this.rating,
  });

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
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  address,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 16),
                Image.network(
                  imageUrl, // 이미지 URL
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16),
                Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      rating,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('리뷰 1개'),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: '리뷰 작성하기',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('리뷰 제출하기'),
                ),
                SizedBox(height: 16),
                Divider(),
                ListTile(
                  leading: CircleAvatar(),
                  title: Text('사용자 이름1'),
                  subtitle: Text('리뷰 내용'),
                  trailing: Text('2024/11/06'),
                ),
                ListTile(
                  leading: CircleAvatar(),
                  title: Text('사용자 이름2'),
                  subtitle: Text('리뷰 내용'),
                  trailing: Text('2024/11/06'),
                ),
                ListTile(
                  leading: CircleAvatar(),
                  title: Text('사용자 이름3'),
                  subtitle: Text('리뷰 내용'),
                  trailing: Text('2024/11/06'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}