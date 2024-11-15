import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geolocator/geolocator.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MapScreen> {
  late KakaoMapController mapController;
  Set<Marker> markers = {}; // Marker variable
  String? latitude;
  String? longitude;

  //현재 위치 정보를 가져와주는 함수
  getGeoData() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }
    //geolocator을 이용하여 현재 위치정보를 가져와 latitude(위도)와 longitude(경도)에 넣어준다.
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude.toString();
      longitude= position.longitude.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getGeoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: KakaoMap(
              onMapCreated: ((controller) async {
                mapController = controller;
                markers.add(Marker(
                  markerId: UniqueKey().toString(),
                  latLng: await mapController.getCenter(),
                ));
                setState(() {});
              }),
              markers: markers.toList(),
              center: LatLng(37.3608681, 126.9306506),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    // Zoom in
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () async {
                    Position position = await Geolocator.getCurrentPosition();            //geolocator을 이용한 현재 위치 정보 가져오기
                    LatLng userLocation = LatLng(position.latitude, position.longitude);

                    mapController.setCenter(userLocation);

                    setState(() {
                      markers.clear();                  //이전에 생긴 마커들은 제거
                      markers.add(Marker(               //현재 위치에 마커 생성
                        markerId: UniqueKey().toString(),
                        latLng: userLocation,
                      ));
                      onCameraIdle: (userLocation, 3);  //마커 생성된 현재 위치로 카메라 이동
                    });
                  },
                  child: Icon(Icons.location_on),
                ),
                SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      markers.clear();
                    });
                  },
                  child: Icon(Icons.refresh),
                  heroTag: 'refresh',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
