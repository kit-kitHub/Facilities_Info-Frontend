import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '정보',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        children: [
          _buildInfoItem(
            title: '버전 정보',
            subtitle: '버전 정보',
            onTap: () {
              // Handle version info tap
            },
          ),
          _buildInfoItem(
            title: 'OS',
            subtitle: 'OS 정보',
            onTap: () {
              // Handle OS info tap
            },
          ),
          _buildInfoItem(
            title: '부가 정보',
            subtitle: '부가 정보',
            onTap: () {
              // Handle additional info tap
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}