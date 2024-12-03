import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:facilities_info/article/article.dart';

import '../article/article_details_page.dart';

class InquiryScreen extends StatefulWidget {
  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  String? selectedQuestionType;
  bool isMarketingConsentGiven = false;
  TextEditingController inquiryController = TextEditingController();
  List<Article> faqs = [];

  @override
  void initState() {
    super.initState();
    fetchArticles(); // 초기 데이터 로딩
  }

  Future<void> fetchArticles() async {
    final faqsResponse = await http.get(Uri.parse('http://3.34.105.70:8080/articles/faqs'));

    if (faqsResponse.statusCode == 200) {
      setState(() {
        faqs = (json.decode(utf8.decode(faqsResponse.bodyBytes)) as List)
            .map((data) => Article.fromJson(data))
            .toList();
      });
    } else {
      throw Exception('Failed to load articles');
    }
  }

  // Send email function
  Future<void> sendEmail(String subject, String body) async {
    String username = 'your_email@example.com'; // Replace with your email
    String password = 'your_email_password'; // Replace with your email password

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Inquiry App')
      ..recipients.add('recipient_email@example.com') // Replace with the recipient email
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Error: $e');
    }
  }
  //이메일 제출
  void handleSubmit() {
    if (selectedQuestionType == null || inquiryController.text.isEmpty) {
      // Add error handling
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('모든 필드를 채워주세요')));
      return;
    }

    String subject = '문의 내용: ${selectedQuestionType ?? '없음'}';
    String body = '질문 유형: ${selectedQuestionType ?? '선택되지 않음'}\n\n내용: ${inquiryController.text}';

    // Send the email
    sendEmail(subject, body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('문의하기'),
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
          children: [
            SizedBox(height: 32),
            // FAQ 리스트
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: faqs.length,
                      itemBuilder: (context, index) {
                        final faq = faqs[index];
                        return ListTile(
                          title: Text(faq.title ?? ''),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleDetailsPage(
                                id: faq.id,
                                type: 'faq',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // 질문 유형 선택
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedQuestionType,
                    hint: Text('질문 유형을 선택해주세요'),
                    items: ['질문 유형 1', '질문 유형 2', '질문 유형 3']
                        .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedQuestionType = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: TextFormField(
                      controller: inquiryController,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        hintText: '내용을 적어주세요',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isMarketingConsentGiven,
                  onChanged: (value) {
                    setState(() {
                      isMarketingConsentGiven = value!;
                    });
                  },
                ),
                Text('정보 제공 동의'),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handleSubmit, // Trigger email submission
                child: Text('제출하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
