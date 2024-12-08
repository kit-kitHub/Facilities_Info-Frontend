import 'package:flutter/material.dart';
import 'dart:math';

import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import '../../Controller/geo_coordinates_service.dart';

class LocationUtils {
  static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // 지구 반지름 (km)
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

class PositionListScreen extends StatelessWidget {
  final List<GeoCoordinates> positions;
  final LatLng center;

  PositionListScreen({required this.positions, required this.center});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('위치 리스트')),
      body: ListView.builder(
        itemCount: positions.length,
        itemBuilder: (context, index) {
          final position = positions[index];
          final distance = LocationUtils.calculateDistance(
            center.latitude,
            center.longitude,
            position.latitude,
            position.longitude,
          ).toStringAsFixed(2);

          return ListTile(
            title: Text(position.facility.name),
            subtitle: Text('거리: $distance km'),
            trailing: Icon(Icons.location_on),
          );
        },
      ),
    );
  }
}