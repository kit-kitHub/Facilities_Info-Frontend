import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/SingleTone/fontSizeManager.dart';
import '/article/article.dart';

class NoticeListPage extends StatefulWidget {
  @override
  _NoticeListPageState createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> {
  List<Article> notices = [];
  List<Article> faqs = [];
  final fontSizeManager = FontSizeManager();

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    final noticesResponse = await http.get(Uri.parse('http://3.34.105.70:8080/articles/notices'));
    final faqsResponse = await http.get(Uri.parse('http://3.34.105.70:8080/articles/faqs'));

    if (noticesResponse.statusCode == 200 && faqsResponse.statusCode == 200) {
      setState(() {
        notices = (json.decode(utf8.decode(noticesResponse.bodyBytes)) as List)
            .map((data) => Article.fromJson(data))
            .toList();
        faqs = (json.decode(utf8.decode(faqsResponse.bodyBytes)) as List)
            .map((data) => Article.fromJson(data))
            .toList();
      });
    } else {
      throw Exception('Failed to load articles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항', style: TextStyle(fontSize: fontSizeManager.fontSize + 8)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: notices.isEmpty && faqs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('공지사항', style: TextStyle(fontSize: fontSizeManager.fontSize + 8, fontWeight: FontWeight.bold)),
          ...notices.map((article) => _buildArticleTile(article)),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildArticleTile(Article article) {
    return ListTile(
      title: Text(article.title, style: TextStyle(fontSize: fontSizeManager.fontSize + 2, fontWeight: FontWeight.w600)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeDetailPage(article: article),
          ),
        );
      },
    );
  }
}

class NoticeDetailPage extends StatelessWidget {
  final Article article;
  final fontSizeManager = FontSizeManager();

  NoticeDetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항 상세', style: TextStyle(fontSize: fontSizeManager.fontSize + 8),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.title, style: TextStyle(fontSize: fontSizeManager.fontSize + 8, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('ID: ${article.id}', style: TextStyle(fontSize: fontSizeManager.fontSize, color: Colors.grey)),
            SizedBox(height: 32),
            Text('상세 내용은 추후 추가 예정입니다.', style: TextStyle(fontSize: fontSizeManager.fontSize)),
          ],
        ),
      ),
    );
  }
}
