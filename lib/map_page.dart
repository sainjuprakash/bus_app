import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _pGooglePxl = LatLng(27.6898595779013, 85.32115165103747);
  static const LatLng _destination =
      LatLng(27.675462605326324, 85.4300373952178);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: _pGooglePxl, zoom: 15),
        markers: {
          const Marker(
            markerId: MarkerId('source'),
            icon: BitmapDescriptor.defaultMarker,
            position: _pGooglePxl,
          ),
          const Marker(
              markerId: MarkerId('destination'),
              icon: BitmapDescriptor.defaultMarker,
              position: _destination),
        },
      ),
    );
  }
}
