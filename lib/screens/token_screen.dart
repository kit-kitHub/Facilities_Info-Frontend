import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TokenScreen extends StatelessWidget {
  final String accessToken;
  final String refreshToken;

  TokenScreen({required this.accessToken, required this.refreshToken});

  void _logout(BuildContext context) async {
    var response = await ApiService.logoutUser(accessToken);

    if (response == "Logout successful") {
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } else {
      // Handle logout failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tokens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Access Token: $accessToken'),
            SizedBox(height: 16.0),
            Text('Refresh Token: $refreshToken'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
