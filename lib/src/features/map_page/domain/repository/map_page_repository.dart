import 'package:google_maps_flutter/google_maps_flutter.dart' as gml;
import 'package:location/location.dart';

abstract class MapRepository {
  Future<void> sendLocation({
    required gml.LatLng position,
    required String bearerToken,
    required int busId,
  });

  Future<bool> checkAndRequestPermissions();
  Stream<LocationData> getLocationUpdate();
  Future<LocationData?> getFirstLocation();
  Stream<double?> getCompassHeading();
  List<gml.Circle> generateCirclesFromPoints(List<gml.LatLng> points);
  Future<void> sendPushNotification();
}
