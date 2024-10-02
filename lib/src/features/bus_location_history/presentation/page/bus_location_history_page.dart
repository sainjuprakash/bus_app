import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusLocationHistoryPage extends StatefulWidget {
  List<LatLng>? locationHistory;
  BusLocationHistoryPage({this.locationHistory, super.key});

  @override
  State<BusLocationHistoryPage> createState() => _BusLocationHistoryPageState();
}

class _BusLocationHistoryPageState extends State<BusLocationHistoryPage> {
  GoogleMapController? _mapController;
  LatLng? currentP = LatLng(27.7172, 85.3240);
  Set<Circle> circles = {};
  Set<Marker> markers = {};
  LatLngBounds? bounds;

  @override
  void initState() {
    super.initState();
    if (widget.locationHistory != null && widget.locationHistory!.isNotEmpty) {
      _createCirclesAndMarkers(widget.locationHistory!);
      _setBoundsForLocations(widget.locationHistory!);
    }
  }

  void _createCirclesAndMarkers(List<LatLng> locations) {
    for (int i = 0; i < locations.length; i++) {
      // Add circle for each location
      circles.add(
        Circle(
          circleId: CircleId('circle_$i'),
          center: locations[i],
          radius: 3, // radius in meters
          fillColor: Colors.redAccent.withOpacity(0.5),
          strokeColor: Colors.redAccent,
          strokeWidth: 1,
        ),
      );
    }

    // Add markers for the first and last locations
    markers.add(
      Marker(
        markerId: MarkerId('start_marker'),
        position: locations.first,
        infoWindow: InfoWindow(title: 'Start'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('end_marker'),
        position: locations.last,
        infoWindow: InfoWindow(title: 'End'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  void _setBoundsForLocations(List<LatLng> locations) {
    if (locations.isNotEmpty) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          locations.map((e) => e.latitude).reduce((a, b) => a < b ? a : b),
          locations.map((e) => e.longitude).reduce((a, b) => a < b ? a : b),
        ),
        northeast: LatLng(
          locations.map((e) => e.latitude).reduce((a, b) => a > b ? a : b),
          locations.map((e) => e.longitude).reduce((a, b) => a > b ? a : b),
        ),
      );
      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentP!, // Default position if no locations
          zoom: 16,
        ),
        circles: circles,
        markers: markers,
        onMapCreated: (controller) {
          _mapController = controller;
          if (widget.locationHistory != null &&
              widget.locationHistory!.isNotEmpty) {
            _setBoundsForLocations(widget.locationHistory!);
          }
        },
      ),
    );
  }
}
