import 'package:flutter/material.dart';
import 'admin_api_controller.dart';

class AdminReportScreen extends StatefulWidget {
  @override
  _AdminReportScreenState createState() => _AdminReportScreenState();
}

class _AdminReportScreenState extends State<AdminReportScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final ApiController _apiController = ApiController();
  List<dynamic> _reports = [];
  bool _isLoading = false;

  Future<void> _fetchReports(String userId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userIdParsed = int.tryParse(userId);
      if (userIdParsed == null) {
        throw Exception("올바른 사용자 ID를 입력하세요.");
      }
      final reports = await _apiController.getUserBlockRecord(userIdParsed);
      setState(() {
        _reports = reports as List;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('신고 내역 조회 실패: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _blockUser(int userId) async {
    try {
      await _apiController.blockUser(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용자가 성공적으로 차단되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 차단 실패: $e')),
      );
    }
  }

  Future<void> _unblockUser(int userId) async {
    try {
      await _apiController.unblockUser(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용자가 성공적으로 차단 해제되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 차단 해제 실패: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('관리자 화면'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 사용자 ID 입력 필드
            TextField(
              controller: _userIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '사용자 ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 신고 결과 영역
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _reports.isEmpty
                  ? const Center(child: Text('신고 내역이 없습니다.'))
                  : ListView.builder(
                itemCount: _reports.length,
                itemBuilder: (context, index) {
                  final report = _reports[index];
                  return Card(
                    child: ListTile(
                      title: Text('신고 ID: ${report['id']}'),
                      subtitle: Text('신고 내용: ${report['content']}'),
                    ),
                  );
                },
              ),
            ),

            // 버튼들 하단 배치
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          final userId = _userIdController.text;
                          final userIdParsed = int.tryParse(userId);
                          if (userIdParsed != null) {
                            _blockUser(userIdParsed);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('올바른 사용자 ID를 입력하세요.')),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          '차단하기',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          final userId = _userIdController.text;
                          final userIdParsed = int.tryParse(userId);
                          if (userIdParsed != null) {
                            _unblockUser(userIdParsed);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('올바른 사용자 ID를 입력하세요.')),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.green, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          '차단 해제하기',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    final userId = _userIdController.text;
                    if (userId.isNotEmpty) {
                      _fetchReports(userId);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('사용자 ID를 입력하세요.')),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    '신고 내역 조회',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
