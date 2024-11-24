import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geocoding/geocoding.dart';

class LocationUtils {
  // 두 좌표 간의 거리를 계산하는 함수 (Haversine 공식 사용)
  static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // 지구 반지름 (km)
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // 거리 반환 (km)
  }

  // 도(degree)를 라디안(radian)으로 변환하는 함수
  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

class PositionListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> positions;
  final LatLng center;

  PositionListScreen({required this.positions, required this.center});

  Future<List<Map<String, dynamic>>> sortPositionsByDistance() async {
    // 위치를 주소에 따라 가져오고 거리를 계산한 후 정렬하는 함수
    List<Map<String, dynamic>> sortedPositions = List.from(positions);
    for (var position in sortedPositions) {
      List<Location> locations = await locationFromAddress(position['address']);
      position['lat'] = locations[0].latitude;
      position['lng'] = locations[0].longitude;
    }

    sortedPositions.sort((a, b) {
      final distanceA = LocationUtils.calculateDistance(
        center.latitude,
        center.longitude,
        a['lat'],
        a['lng'],
      );
      final distanceB = LocationUtils.calculateDistance(
        center.latitude,
        center.longitude,
        b['lat'],
        b['lng'],
      );
      return distanceA.compareTo(distanceB); // 거리 기준 오름차순 정렬
    });

    return sortedPositions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('위치 리스트')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: sortPositionsByDistance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No locations found.'));
          }

          final positions = snapshot.data!;

          return ListView.builder(
            itemCount: positions.length,
            itemBuilder: (context, index) {
              final position = positions[index];
              final distance = LocationUtils.calculateDistance(
                center.latitude,
                center.longitude,
                position['lat'],
                position['lng'],
              ).toStringAsFixed(2);

              return ListTile(
                title: Text(position['title']),
                subtitle: Text('거리: $distance km'),
                trailing: Icon(Icons.location_on),
              );
            },
          );
        },
      ),
    );
  }
}