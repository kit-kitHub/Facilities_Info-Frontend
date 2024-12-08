import 'package:flutter/material.dart';
import 'facility_service.dart';

class FacilitiesSearchPage extends StatefulWidget {
  @override
  _FacilitiesSearchPageState createState() => _FacilitiesSearchPageState();
}

class _FacilitiesSearchPageState extends State<FacilitiesSearchPage> {
  late Future<List<Facility>> futureFacilities;
  String? searchName;
  String? searchType = '';

  @override
  void initState() {
    super.initState();
    futureFacilities = searchFacilities();
  }

  void _search() {
    setState(() {
      futureFacilities = searchFacilities(name: searchName, type: searchType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facilities Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                searchName = value;
              },
            ),
            ElevatedButton(
              onPressed: _search,
              child: Text('Search'),
            ),
            Expanded(
              child: FutureBuilder<List<Facility>>(
                future: futureFacilities,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Facility> facilities = snapshot.data!;
                    return ListView.builder(
                      itemCount: facilities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(facilities[index].name),
                          subtitle: Text(facilities[index].address),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
