import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

dynamic haversineDistance(LatLng player1, LatLng player2) {
  double lat1 = player1.latitude;
  double lon1 = player1.longitude;
  double lat2 = player2.latitude;
  double lon2 = player2.longitude;

  var R = 6371e3; // metres
  // var R = 1000;
  var phi1 = (lat1 * pi) / 180; // φ, λ in radians
  var phi2 = (lat2 * pi) / 180;
  var deltaPhi = ((lat2 - lat1) * pi) / 180;
  var deltaLambda = ((lon2 - lon1) * pi) / 180;

  var a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
      cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);

  var c = 2 * atan2(sqrt(a), sqrt(1 - a));

  var d = R * c; // in metres

  return d;
}
