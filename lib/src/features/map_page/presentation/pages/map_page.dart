import 'dart:async';

import 'package:bus_app/src/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  static const LatLng _pGooglePxl = LatLng(27.6898595779013, 85.32115165103747);
  static const LatLng _destination =
      LatLng(27.675462605326324, 85.4300373952178);
  LatLng? currentP;
  double currentZoom = 18.0;
  List<LatLng> _polylineCoordinates = [];
  Set<Circle> circles = {};
  Map<PolylineId, Polyline> polylines = {};

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then((_) {
      getPolylinePoints()
          .then((coordinates) => generateCirclesFromPoints(coordinates));
      getLocationUpdates().then((_) => {
            getPolylinePoints().then(
                (coordinates) => {generatePolylineFromPoints(coordinates)})
          });
    });

    // Initialize the timer to update the polyline periodically
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      if (currentP != null) {
        setState(() {
          _polylineCoordinates.add(currentP!);
          generateCirclesFromPoints(_polylineCoordinates);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Maps'),
        backgroundColor: Colors.white,
      ),
      body: currentP == null
          ? const Center(child: Text('Loading...'))
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              initialCameraPosition:
                  CameraPosition(target: currentP!, zoom: currentZoom),
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: currentP!,
                ),
                const Marker(
                  markerId: MarkerId('destinationLocation'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _destination,
                ),
              },
              circles: circles,
              polylines: Set<Polyline>.of(polylines.values),
              onCameraMove: (CameraPosition position) {
                currentZoom = position.zoom;
              },
            ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition =
        CameraPosition(target: pos, zoom: currentZoom);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
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
          _cameraToPosition(currentP!);
          // print("current position : $currentP");
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinate = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(_pGooglePxl.latitude, _pGooglePxl.longitude),
        destination: PointLatLng(_destination.latitude, _destination.longitude),
        mode: TravelMode.driving,
      ),
      googleApiKey: GOOGLE_API_KEY,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinate.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinate;
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId('poly');
    Polyline polyLine = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 5);
    setState(() {
      polylines[id] = polyLine;
    });
  }

  void generateCirclesFromPoints(List<LatLng> polylineCoordinates) async {
    Set<Circle> newCircles = {};
    for (int i = 0; i < polylineCoordinates.length; i++) {
      newCircles.add(Circle(
        circleId: CircleId('circle_$i'),
        center: polylineCoordinates[i],
        radius: 3, // Radius in meters
        fillColor: Colors.red,
        strokeColor: Colors.black,
        strokeWidth: 1,
      ));
    }
    setState(() {
      circles = newCircles;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
}
