import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'Search_1.dart';
import 'Menu.dart';

void main() {
  AuthRepository.initialize(appKey: 'fd3b1ea02a770944b136c4a2ffdf5262');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late KakaoMapController mapController;
  Set<Marker> markers = {}; // Marker variable

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          // Map Page
          Stack(
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

                    setState(() { });
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
                      onPressed: () async { // Zoom in
                      },
                      child: Icon(Icons.add),
                      heroTag: 'zoomIn',
                    ),
                    SizedBox(height: 20),
                    FloatingActionButton(
                      onPressed: () async {
                        final center = await mapController.getCenter();
                        // Center map action
                      },
                      child: Icon(Icons.location_on),
                      heroTag: 'location',
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
          // Search Page
          Search_1(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
