import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gml;
//import 'package:latlong2/latlong.dart'as latLng;
import 'package:location/location.dart';

abstract class MapRepository {
  Future<void> sendLocation({
    required gml.LatLng position,
    required String bearerToken,
    required int busId,
     bool? isStart,
  });

  Future<void> checkAndRequestPermissions();
  Stream<LocationData> getLocationUpdate();
  Future<LocationData?> getFirstLocation();
  Stream<double?> getCompassHeading();
  List<gml.Circle> generateCirclesFromPoints(List<gml.LatLng> points);
  Future<void> sendPushNotification();
  void startTrackingSpeed();
  void startTracking(
      {required int selectedNumber,
      required Function(gml.LatLng) onLocationUpdate});
  String formatElapsedTime();
  double getTotalDistance();
  double getCurrentSpeed();
  void dispose();
}
