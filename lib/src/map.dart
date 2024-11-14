import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MapScreen> {
  late KakaoMapController mapController;
  Set<Marker> markers = {}; // Marker variable

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
                    // Center on user location
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
