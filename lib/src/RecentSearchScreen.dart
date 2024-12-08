import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../Controller/geo_coordinates_service.dart';
import '../main.dart';
import '/SingleTone/font.dart';
import '/SingleTone/Recent_Search.dart';
import 'map/geolocation.dart';


class RecentSearchScreen extends StatefulWidget {
  @override
  _RecentSearchScreenState createState() => _RecentSearchScreenState();
}

class _RecentSearchScreenState extends State<RecentSearchScreen> {
  String? searchName;
  Future<List<Facility>>? futureFacilities;
  List<GeoCoordinates> findItems = [];
  GeoCoordinates? findItemsfac;
  final fontSizeManager = FontSizeManager();
  final recentSearch = RecentSearch(); // 싱글톤 인스턴스 사용
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFacilities();
    _loadRecentSearches(); // 최근 검색 초기화
  }

  void _initializeFacilities() async {
    try {
      findItems = await fetchGeoCoordinates(36.146508, 128.393532, 1000.0);
      setState(() {});
    } catch (e) {
      print('Error loading facilities: $e');
    }
  }

  Future<void> _loadRecentSearches() async {
    await recentSearch.initialize();
    setState(() {});
  }

  void _searchFacilities() {
    setState(() {
      searchName = _textEditingController.text;
      futureFacilities = searchFacilities(name: searchName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _textEditingController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _searchFacilities();
              });
              _textEditingController.clear();
            }
          },
          decoration: InputDecoration(
            hintText: '검색 내용 작성칸',
            hintStyle: TextStyle(color: Colors.grey, fontSize: fontSizeManager.fontSize - 4),
            border: InputBorder.none,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (futureFacilities != null) ...[
              Text('검색 결과', style: TextStyle(fontSize: fontSizeManager.fontSize + 2, fontWeight: FontWeight.bold)),
              Divider(),
              Expanded(
                child: FutureBuilder<List<Facility>>(
                  future: futureFacilities,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final facility = snapshot.data![index];
                          findItemsfac = findItems.firstWhereOrNull((item) => item.facility.name == facility.name);
                          double longitude = findItemsfac?.longitude ?? 0.0;
                          double latitude = findItemsfac?.latitude ?? 0.0;
                          return ListTile(
                            title: Text(facility.name),
                            subtitle: Text(facility.address),
                            onTap: () {
                              if (findItemsfac != null) {
                                setState(() {
                                  recentSearch.addRecentSearch(facility.name); // 최근 검색 추가
                                });
                                mapcentermanager.setMapCenterLongitude(longitude);
                                mapcentermanager.setMapCenterLatitude(latitude);
                                mapcentermanager.setLevel(1);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('위치 정보를 찾을 수 없습니다.')),
                                );
                              }
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return Center(child: Text('검색 결과가 없습니다.'));
                    }
                  },
                ),
              ),
            ] else ...[
              Text('최근 검색', style: TextStyle(fontSize: fontSizeManager.fontSize + 2, fontWeight: FontWeight.bold)),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: recentSearch.recentSearches.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Flexible(
                          flex: 13,
                          child: TextButton(
                            onPressed: () {
                              String selectedName = recentSearch.recentSearches[index]['name']!;
                              GeoCoordinates? selectedCoordinates = findItems.firstWhereOrNull(
                                      (item) => item.facility.name == selectedName);

                              if (selectedCoordinates != null) {
                                double longitude = selectedCoordinates.longitude;
                                double latitude = selectedCoordinates.latitude;

                                mapcentermanager.setMapCenterLongitude(longitude);
                                mapcentermanager.setMapCenterLatitude(latitude);

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('해당 위치 정보를 찾을 수 없습니다.')),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Icon(Icons.search),
                                SizedBox(width: 16),
                                Text(
                                  recentSearch.recentSearches[index]['name']!,
                                  style: TextStyle(color: Colors.black87, fontSize: fontSizeManager.fontSize - 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () async {
                              await recentSearch.removeRecentSearch(index);
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
