import 'package:flutter/material.dart';
import '/main.dart';
import 'report_api_controller.dart';
import '/SingleTone/fontSizeManager.dart';

class ReportScreen extends StatefulWidget {
  final String contentType;
  final int reviewId;

  // 생성자에서 리뷰 ID와 콘텐츠 유형을 전달받음
  ReportScreen({required this.contentType, required this.reviewId});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _reasonController = TextEditingController();
  String? _typeController;
  final fontSizeManager = FontSizeManager();

  // 신고 생성 함수
  void _createReport() async {
    // 필수 입력값 체크
    if (_reasonController.text.isEmpty || _typeController == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이유와 신고 유형을 모두 선택해 주세요', style: TextStyle(fontSize: fontSizeManager.fontSize),)),
      );
      return;
    }

    final reportData = {
      'reason': _reasonController.text,
      'type': _typeController,
    };

    final response = await ApiController.createReport(
      widget.contentType, // 전달된 콘텐츠 유형
      widget.reviewId, // 전달된 리뷰 ID
      reportData,
    );

    if (response.statusCode == 200) {
      // 신고 성공 시 이전 화면으로 이동
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('신고되었습니다!', style: TextStyle(fontSize: fontSizeManager.fontSize),)));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // HomeScreen으로 이동
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('오류로 인해 신고에 실패하였습니다', style: TextStyle(fontSize: fontSizeManager.fontSize),)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('신고 하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 신고 이유 입력 (텍스트 필드 크기 동적으로 증가)
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: '이유',
                ),
                maxLines: null, // 이 속성을 설정하여 입력 시 필드 크기가 늘어나도록 함
                keyboardType: TextInputType.multiline, // 여러 줄 입력을 허용
                minLines: 1, // 최소 1줄
              ),
              // 신고 유형 입력
              DropdownButtonFormField<String>(
                value: _typeController,
                hint: Text('신고 유형을 선택해주세요', style: TextStyle(fontSize: fontSizeManager.fontSize),),
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createReport,
                child: Text('신고 제출', style: TextStyle(fontSize: fontSizeManager.fontSize),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
