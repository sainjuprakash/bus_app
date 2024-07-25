import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();
  static const LatLng _pGooglePxl = LatLng(27.6898595779013, 85.32115165103747);
  static const LatLng _destination =
      LatLng(27.675462605326324, 85.4300373952178);
  LatLng? currentP = null;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition:
            const CameraPosition(target: _pGooglePxl, zoom: 15),
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

  Future<void> getLocationUpdates() async {
    print('====================================================');
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.longitude != null &&
          currentLocation.latitude != null) {
        setState(() {
          currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print('-----------------------------');
          print(currentP);
        });
      }
    });
  }
}
