import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DistanceTracker extends StatefulWidget {
  @override
  _DistanceTrackerState createState() => _DistanceTrackerState();
}

class _DistanceTrackerState extends State<DistanceTracker> {
  Position? _lastPosition;
  double _totalDistance = 0.0; // In meters
  double _currentSpeed = 0.0; // In meters per second

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  void _startTracking() async {
    // Check and request location permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Minimum distance (in meters) to trigger an update
      ),
    ).listen((Position position) {
      if (_lastPosition != null) {
        final distance = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        setState(() {
          _totalDistance += distance;
          _currentSpeed = position.speed; // Speed in m/s
        });
      }
      _lastPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Distance and Speed Tracker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Total Distance: ${(_totalDistance / 1000).toStringAsFixed(2)} km"),
            Text(
                "Current Speed: ${(_currentSpeed * 3.6).toStringAsFixed(2)} km/h"),
          ],
        ),
      ),
    );
  }
}
