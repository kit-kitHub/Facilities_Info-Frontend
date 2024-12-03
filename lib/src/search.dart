import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import '../Controller/geo_coordinates_service.dart';
import '../SingleTone/map_center.dart';
import '../main.dart';
import '/SingleTone/font.dart';
import 'RecentSearchScreen.dart';
import 'map/Locations.dart';
import 'map/geolocation.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

IconData getIconForType(String type) {
  switch (type) {
    case 'PARKING_LOT':
      return Icons.local_parking;
    case 'WELFARE_CENTER':
      return Icons.volunteer_activism;
    case 'MEDICAL_FACILITY':
      return Icons.local_hospital;
    case 'RESTROOM':
      return Icons.wc;
    default:
      return Icons.location_on;
  }
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final fontSizeManager = FontSizeManager();
  late TabController _tabController;
  List<GeoCoordinates> filteredItems = [];
  List<GeoCoordinates> facilities = [];
  String? searchName;
  final LatLng initialPosition = LatLng(0, 0); // 초기 위치 추가
  final mapcentermanager = mapCenterManager();


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    _initializeFacilities();

    filteredItems = facilities;

    // Add listener to tab changes
    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 0) {
          // 전체 (All items)
          filteredItems = facilities;
        } else if (_tabController.index == 1) {
          // 주차장
          filteredItems = facilities.where((item) => item.facility.type == 'PARKING_LOT').toList();
        } else if (_tabController.index == 2) {
          // 복지센터
          filteredItems = facilities.where((item) => item.facility.type == 'WELFARE_CENTER').toList();
        } else if (_tabController.index == 3) {
          // 의료시설
          filteredItems = facilities.where((item) => item.facility.type == 'MEDICAL_FACILITY').toList();
        } else if (_tabController.index == 4) {
          // 화장실
          filteredItems = facilities.where((item) => item.facility.type == 'RESTROOM').toList();
        }
      });
    });
  }

  void _initializeFacilities() async {
    try {
      LatLng center = LatLng(mapcentermanager.mapCenterlatitude, mapcentermanager.mapCenterlongitude);
      List<GeoCoordinates> positionsList = await fetchGeoCoordinates(mapcentermanager.mapCenterlatitude, mapcentermanager.mapCenterlongitude, 10.0);

      positionsList.sort((a, b) {
        final double distanceA = LocationUtils.calculateDistance(
          center.latitude,
          center.longitude,
          a.latitude,
          a.longitude,
        );
        final double distanceB = LocationUtils.calculateDistance(
          center.latitude,
          center.longitude,
          b.latitude,
          b.longitude,
        );
        return distanceA.compareTo(distanceB); // 거리 기준 오름차순 정렬
      });

      // setState()를 UI 업데이트만 위해 사용
      setState(() {
        facilities = positionsList;
        filteredItems = positionsList; // 초기 상태에서 필터링된 항목을 설정
      });
    } catch (e) {
      print('Error loading facilities: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.circle, color: Colors.white),
        title: GestureDetector(
          onTap: () {},
          child: AbsorbPointer(
            child: TextField(
              decoration: InputDecoration(
                hintText: '근처 정보 보기',
                hintStyle: TextStyle(fontSize: fontSizeManager.fontSize - 4),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              enabled: false, // Disables editing in the TextField
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () {
              // Handle microphone action
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          labelStyle: TextStyle(
            fontSize: fontSizeManager.fontSize - 4,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelColor: Colors.black,
          unselectedLabelStyle: TextStyle(
            fontSize: fontSizeManager.fontSize - 4,
          ),
          indicatorColor: Colors.blue,
          tabs: [
            Tab(text: '전체'),
            Tab(text: '주차장'),
            Tab(text: '복지센터'),
            Tab(text: '의료시설'),
            Tab(text: '화장실'),
          ],
        ),
      ),
      body: ListView(
        children: filteredItems.map((item) {
          return MenuButton(
            icon: getIconForType(item.facility.type),
            text: item.facility.name,
            onPressurl: item.facility.imageUrl,
            fontSizeManager: fontSizeManager,// Placeholder URL
            position: LatLng(item.latitude, item.longitude),
          );
        }).toList(),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final LatLng position;
  final String text;
  final String onPressurl;
  final fontSizeManager;
  const MenuButton({Key? key, required this.icon, required this.text, required this.onPressurl, required this.fontSizeManager, required this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextButton(
        onPressed: () {
          mapcentermanager.setMapCenterLongitude(position.longitude);
          mapcentermanager.setMapCenterLatitude(position.latitude);
          mapcentermanager.setLevel(1);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black54),
            SizedBox(width: 12),
            Text(text, style: TextStyle(color: Colors.black87, fontSize: fontSizeManager.fontSize - 4)),
          ],
        ),
      ),
    );
  }
}