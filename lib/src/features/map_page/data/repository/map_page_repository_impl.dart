import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bus_app/src/features/map_page/domain/repository/map_page_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gml;

class MapRepositoryImpl extends MapRepository {
  @override
  Future<void> sendLocation(
      {required gml.LatLng position,
      required String bearerToken,
      required int busId}) async {
    const String url = 'https://gps.git.com.np/api/v1/location-update';

    DateTime now = DateTime.now();
    String formattedTime =
        "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} "
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode({
          'bus_id': busId,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'time': formattedTime,
        }),
      );

      if (response.statusCode == 200) {
        print('Location sent successfully');
      } else {
        print('Failed to send location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending location: $e');
    }
  }
}
