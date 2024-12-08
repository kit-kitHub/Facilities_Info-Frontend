import 'package:flutter/material.dart';
import 'geo_coordinates_service.dart';

class GeoCoordinatesPage extends StatefulWidget {
  @override
  _GeoCoordinatesPageState createState() => _GeoCoordinatesPageState();
}

class _GeoCoordinatesPageState extends State<GeoCoordinatesPage> {
  late Future<List<GeoCoordinates>> futureGeoCoordinates;

  @override
  void initState() {
    super.initState();
    futureGeoCoordinates = fetchGeoCoordinates(36.146508, 128.393532, 10.0); // 예시 좌표와 반경 설정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geo Coordinates'),
      ),
      body: Center(
        child: FutureBuilder<List<GeoCoordinates>>(
          future: futureGeoCoordinates,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<GeoCoordinates> geoCoordinates = snapshot.data!;
              return ListView.builder(
                itemCount: geoCoordinates.length,
                itemBuilder: (context, index) {
                  GeoCoordinates coord = geoCoordinates[index];
                  return ListTile(
                    title: Text('Latitude: ${coord.latitude}, Longitude: ${coord.longitude}'),
                    subtitle: Text('Facility: ${coord.facility.name}, Address: ${coord.facility.address}'),
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
    );
  }
}
