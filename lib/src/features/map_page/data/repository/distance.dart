import 'package:geolocator/geolocator.dart';
import 'dart:math';

class LocationService {
  Position? _lastPosition;
  double _totalDistance = 0.0;

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // in meters
      ),
    );
  }

  double calculateDistance(Position start, Position end) {
    const R = 6371e3; // Earth's radius in meters
    final lat1 = start.latitude * pi / 180;
    final lat2 = end.latitude * pi / 180;
    final deltaLat = (end.latitude - start.latitude) * pi / 180;
    final deltaLon = (end.longitude - start.longitude) * pi / 180;

    final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distance in meters
  }

  void trackLocation() {
    getPositionStream().listen((Position position) {
      if (_lastPosition != null) {
        final distance = calculateDistance(_lastPosition!, position);
        _totalDistance += distance;

        final timeInSeconds =
            position.timestamp!.difference(_lastPosition!.timestamp!).inSeconds;
        final speed = distance / timeInSeconds; // Speed in meters per second

        print('Distance covered: ${_totalDistance.toStringAsFixed(2)} m');
        print(
            'Speed: ${(speed * 3.6).toStringAsFixed(2)} km/h'); // Convert to km/h
      }
      _lastPosition = position;
    });
  }
}
