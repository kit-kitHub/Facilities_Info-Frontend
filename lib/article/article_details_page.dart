import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';

class ArticleDetailsPage extends StatelessWidget {
  final int id;
  final String type; // "notice" or "faq"

  ArticleDetailsPage({required this.id, required this.type});

  Future<Map<String, dynamic>> fetchArticleDetails() async {
    final response = await http.get(Uri.parse('http://3.34.105.70:8080/articles/${type}s/$id'));

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load article details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$type Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchArticleDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No details available'));
          } else {
            final article = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article['title'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Author: ${article['author']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Html(data: article['content']),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
