import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  static final MapState _instance = MapState._internal();

  factory MapState() {
    return _instance;
  }

  MapState._internal();

  List<LatLng> polylineCoordinates = [];
  Set<Circle> circles = {};
  Map<PolylineId, Polyline> polylines = {};
}

final mapState = MapState();
