import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/SingleTone/fontSizeManager.dart';
import '/SingleTone/deviceInfo.dart';


class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreen();
}

class _InfoScreen extends State<InfoScreen> {
  final fontSizeManager = FontSizeManager();  // FontSizeManager 로드
  final deviceInfo = DeviceInfo();            // DeviceInfo 로드
  String _appVersion = '로딩 중...';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version} ${packageInfo.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // AppBar
      appBar: AppBar(
        title: Text(
          '정보',
          style: TextStyle(
          fontSize: fontSizeManager.fontSize + 4, // default : 20
          fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),

      // Body
      body: ListView(
        children: [
          _buildInfoItem(
            title: '앱 버전',
            subtitle: _appVersion,
            onTap: () {},
          ),
          _buildInfoItem(
            title: 'OS 버전',
            subtitle: '${deviceInfo.osName} ${deviceInfo.osVersion}',
            onTap: () {},
          ),
          _buildInfoItem(
            title: '부가 정보',
            subtitle: '${deviceInfo.manufacturer} ${deviceInfo.deviceModel}',
            onTap: () {},
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            title,
            style: TextStyle(
              fontSize: fontSizeManager.fontSize + 1, // default : 17
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: fontSizeManager.fontSize, // default : 16
              color: Colors.black54,
            ),
          ),
          // trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(height: 1, thickness: 0.5),
      ],
    );
  }
}