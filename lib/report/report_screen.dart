import 'package:flutter/material.dart';
import '/main.dart';
import 'report_api_controller.dart';
import '/SingleTone/fontSizeManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportScreen extends StatefulWidget {
  final String contentType;
  final int reviewId;

  ReportScreen({required this.contentType, required this.reviewId});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? _typeController;
  final TextEditingController _contentController = TextEditingController();
  final fontSizeManager = FontSizeManager();

  // Method to get access token from SharedPreferences
  Future<String?> _getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Method to create a report
  void _createReport() async {
    if ((_typeController?.isEmpty ?? true) || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('신고 유형과 내용을 모두 입력해 주세요',
            style: TextStyle(fontSize: fontSizeManager.fontSize))),
      );
      return;
    }

    final reportData = {
      'type': _typeController,
      'reason': _contentController.text,
    };

    // Fetch access token before making the API call
    String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다.',
            style: TextStyle(fontSize: fontSizeManager.fontSize))),
      );
      return;
    }

    final response = await ApiController.createReport(
      widget.contentType,
      widget.reviewId,
      reportData,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('신고되었습니다!',
            style: TextStyle(fontSize: fontSizeManager.fontSize))),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류로 인해 신고에 실패하였습니다',
            style: TextStyle(fontSize: fontSizeManager.fontSize))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('신고 화면'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _typeController,
                      hint: Text('신고 유형을 선택해주세요'),
                      items: ['신고 유형 1', '신고 유형 2', '신고 유형 3']
                          .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _typeController = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: '신고 내용',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: fontSizeManager.fontSize,
                        ),
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _createReport,
                  child: Text(
                    '신고하기',
                    style: TextStyle(
                      fontSize: fontSizeManager.fontSize,
                      color: Colors.red,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
