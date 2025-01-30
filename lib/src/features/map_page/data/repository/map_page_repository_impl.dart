import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart' as geoLocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:bus_app/src/features/map_page/domain/repository/map_page_repository.dart';
import 'package:location/location.dart';

class MapRepositoryImpl extends MapRepository {
  final Location _locationController = Location();
  geoLocator.Position? _lastPosition;
  double _totalDistance = 0.0; // Total distance in meters
  double _currentSpeed = 0.0;

  final StreamController<double> _speedController =
      StreamController<double>.broadcast();
  @override
  Stream<double> get speedStream => _speedController.stream;

  @override
  Future<void> sendLocation(
      {required LatLng position,
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
      if (response.statusCode != 200) {
        throw Exception('Failed to send location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending location: $e');
    }
  }

  @override
  Future<bool> checkAndRequestPermissions() async {
    bool serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    }

    PermissionStatus permissionGranted =
        await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  @override
  Stream<LocationData> getLocationUpdate() {
    return _locationController.onLocationChanged;
  }

  @override
  Stream<double?> getCompassHeading() {
    return FlutterCompass.events!.map((event) => event.heading);
  }

  @override
  List<Circle> generateCirclesFromPoints(List<LatLng> points) {
    List<Circle> circles = [];
    for (int i = 0; i < points.length; i++) {
      circles.add(
        Circle(
          circleId: CircleId('circle_$i'),
          center: points[i],
          radius: 10, // Customize the radius as needed
          strokeWidth: 2,
          strokeColor: Colors.red,
          fillColor: Colors.red.withOpacity(0.3),
        ),
      );
    }
    return circles;
  }

  Future<void> sendPushNotification() async {
    const String oneSignalAppId = 'df22f16f-5671-4ab8-8f8a-87d82c2886e9';
    const String oneSignalRestApiKey =
        'os_v2_app_34rpc32wofflrd4kq7mcykeg5ear7vmorypeqevi7amgcuubxygedadhno3fhdi6c4n5xhxddxqyugsyqwk73t6cwkxxwinwubg2obq';
    const String url = 'https://onesignal.com/api/v1/notifications';

    final Map<String, dynamic> notification = {
      'app_id': oneSignalAppId,
      'included_segments': ['All'], // Sends to all subscribed users
      'headings': {'en': 'Arrival of the bus'},
      'contents': {'en': 'Hurry Up! Bus is near to your area'},
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic $oneSignalRestApiKey',
      },
      body: json.encode(notification),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }

  @override
  Future<LocationData?> getFirstLocation() async {
    try {
      bool hasPermission = await checkAndRequestPermissions();
      if (!hasPermission) {
        print('Location permission not granted.');
        return null;
      }

      bool serviceEnabled = await _locationController.serviceEnabled();
      if (!serviceEnabled) {
        print('Location services are not enabled.');
        return null;
      }
      // Get the first location data
      LocationData firstLocation = await _locationController.getLocation();
      LatLng parentsLocation =
          LatLng(firstLocation.latitude!, firstLocation.longitude!);
      print(
          'First location: ${firstLocation.latitude}, ${firstLocation.longitude}');
      return firstLocation;
    } catch (e) {
      print('Error retrieving first location: $e');
      return null;
    }
  }
}
