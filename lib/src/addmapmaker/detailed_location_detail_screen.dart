import 'package:flutter/material.dart';
import 'detailed_location.dart';

class DetailedLocationDetailScreen extends StatelessWidget {
  final DetailedLocation detailedLocation;

  DetailedLocationDetailScreen({required this.detailedLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(detailedLocation.location),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detailedLocation.location,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Rating: ${detailedLocation.rating}'),
            SizedBox(height: 10),
            Text('Latitude: ${detailedLocation.latitude}'),
            Text('Longitude: ${detailedLocation.longitude}'),
            // 추가 정보는 필요에 따라 여기에 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }
}
