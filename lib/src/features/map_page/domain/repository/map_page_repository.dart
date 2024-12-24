import 'package:google_maps_flutter/google_maps_flutter.dart' as gml;

abstract class MapRepository {
  Future<void> sendLocation({
    required gml.LatLng position,
    required String bearerToken,
    required int busId,
  });
}
