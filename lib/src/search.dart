import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> menuItems = [];
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Define menu items with categories
    menuItems = [
      {'icon': Icons.favorite, 'text': '양포동 영상복지센터', 'category': '복지센터', 'url': 'fsdfsd'},
      {'icon': Icons.add, 'text': '서울필의원', 'category': '의료시설', 'url': 'fsdfsd'},
      {'icon': Icons.favorite, 'text': '신동읍 영상복지센터', 'category': '복지센터', 'url': 'fsdfsd'},
      {'icon': Icons.favorite, 'text': '구미시 장애인 종합 복지관', 'category': '복지센터', 'url': 'fsdfsd'},
    ];

    // Initialize to show all items (for the "전체" tab)
    filteredItems = menuItems;

    // Add listener to tab changes
    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 0) {
          // 전체 (All items)
          filteredItems = menuItems;
        } else if (_tabController.index == 1) {
          // 주차장
          filteredItems = menuItems.where((item) => item['category'] == '주차장').toList();
        } else if (_tabController.index == 2) {
          // 복지센터
          filteredItems = menuItems.where((item) => item['category'] == '복지센터').toList();
        } else if (_tabController.index == 3) {
          // 의료시설
          filteredItems = menuItems.where((item) => item['category'] == '의료시설').toList();
        } else if (_tabController.index == 4) {
          // 화장실
          filteredItems = menuItems.where((item) => item['category'] == '화장실').toList();
        }
      });
    });
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
          onTap: () {
            // Navigate to RecentSearchScreen when tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecentSearchScreen()),
            );
          },
          child: AbsorbPointer(
            child: TextField(
              decoration: InputDecoration(
                hintText: '검색 내용 작성칸',
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
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelColor: Colors.black,
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
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
            icon: item['icon'],
            text: item['text'],
            onPressurl: item['url'], // Placeholder URL
          );
        }).toList(),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final String onPressurl;

  const MenuButton({Key? key, required this.icon, required this.text, required this.onPressurl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextButton(
        onPressed: () {
          // Navigate or perform action based on onPressurl
        },
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black54),
            SizedBox(width: 12),
            Text(text, style: TextStyle(color: Colors.black87, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class RecentSearchScreen extends StatefulWidget {
  @override
  _RecentSearchScreenState createState() => _RecentSearchScreenState();
}

class _RecentSearchScreenState extends State<RecentSearchScreen> {
  final List<Map<String, String>> recentSearches = [
    {'name': '금오공과대학교', 'url': 'https://kumoh.ac.kr'},
    {'name': '양포동 행정복지센터', 'url': 'https://yangpocity.kr'},
    {'name': '거의동 병원', 'url': 'https://geoidonghospital.kr'},
  ];

  final TextEditingController _textEditingController = TextEditingController();

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
          textInputAction: TextInputAction.go,
          onSubmitted: (value) async {
            // Add entered value to recent searches list if it's not empty
            if (value.isNotEmpty) {
              setState(() {
                recentSearches.insert(0, {'name': value, 'url' : 'fdsafas'}); // Insert at the beginning of the list
              });
              _textEditingController.clear(); // Clear the TextField after submission
            }
          },
          decoration: InputDecoration(
            hintText: '검색 내용 작성칸',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('최근검색', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Flexible(
                        flex: 13,
                        child: TextButton(
                          onPressed: () {

                          },
                          child: Row(
                            children: [
                              Icon(Icons.search),
                              SizedBox(width: 16),
                              Text(recentSearches[index]['name']!, style: TextStyle(color: Colors.black87, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              recentSearches.removeAt(index); // Remove item from recent searches
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}