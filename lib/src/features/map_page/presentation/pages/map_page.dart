import 'dart:async';
import 'dart:convert';
import 'package:bus_app/core/service/shared_preference_service.dart';
import 'package:http/http.dart' as http;
import 'package:bus_app/src/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:workmanager/workmanager.dart';

import '../../../home_page/data/model/bus_location.dart';

class MapPage extends StatefulWidget {
  List<BusLocationModel>? busLocationModel;
  MapPage({this.busLocationModel, super.key});

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
  String? bearerToken;
  int? busId;
  int _selectedTime = 10;
  int selectedNumber = 10;
  final int minNumber = 5;
  final int maxNumber = 120; // You can adjust this as neede

  bool _isTracking = false; // To control location tracking

  @override
  void initState() {
    print('------------------------');
    print(widget.busLocationModel);
    super.initState();
    getDataFromSharedPrefs();
    getLocationUpdates(); // We get location updates but don't generate circles until tracking starts

    // Get polyline points initially, but don't start the timer until tracking starts
    // getPolylinePoints().then((coordinates) {
    //   setState(() {
    //     _polylineCoordinates = coordinates;
    //     generateCirclesFromPoints(coordinates);
    //   });
    // });
  }

  // Start tracking location when button is pressed
  void _startTracking() {
    if (!_isTracking) {
      setState(() {
        _isTracking = true;
      });
      _startTimer(); // Start the periodic task
    } else {
      setState(() {
        _isTracking = false;
      });
      _timer?.cancel(); // Stop the periodic task
    }
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel the existing timer if any
    _timer = Timer.periodic(Duration(seconds: selectedNumber), (Timer t) {
      if (currentP != null) {
        setState(() {
          _polylineCoordinates.add(currentP!);
          generateCirclesFromPoints(_polylineCoordinates);
        });
        _sendLocationToServer(currentP!);

        Workmanager().registerOneOffTask(
          'location_task',
          'send_location_task',
          initialDelay: const Duration(seconds: 1),
          inputData: {
            'latitude': currentP!.latitude,
            'longitude': currentP!.longitude,
          },
        );
      }
    });
  }

  Future<void> getDataFromSharedPrefs() async {
    final _prefs = await PrefsService.getInstance();
    bearerToken = _prefs.getString(PrefsServiceKeys.accessTokem);
    busId = _prefs.getInt(PrefsServiceKeys.busId);
  }

  Future<void> _sendLocationToServer(LatLng position) async {
    const String url =
        'https://gps.git.com.np/api/v1/location-update'; // Replace with your actual endpoint

    DateTime now = DateTime.now();
    String formattedTime =
        "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} "
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode({
          'bus_id': busId,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'time': formattedTime,
        }),
      );

      if (response.statusCode == 200) {
        print('Location sent successfully');
      } else {
        print('Failed to send location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentP == null
          ? const Center(child: Text('Loading...'))
          : Stack(
              children: [
                GoogleMap(
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
                  },
                  circles: circles,
                  polylines: Set<Polyline>.of(polylines.values),
                  onCameraMove: (CameraPosition position) {
                    currentZoom = position.zoom;
                  },
                ),
                Align(
                  alignment: const Alignment(0, -0.91),
                  child: Container(
                    height: 50,
                    width: double.maxFinite,
                    color: Colors.grey.withOpacity(0.6),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (maxNumber - minNumber) ~/ 5 + 1,
                      itemBuilder: (context, index) {
                        int number = minNumber + index * 5;
                        bool isSelected = number == selectedNumber;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedNumber = number;
                              if (_isTracking) {
                                _startTimer(); // Restart the timer with new interval
                              }
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 60,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? Colors.blue : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${number.toString()}s",
                              style: TextStyle(
                                fontSize: isSelected ? 24 : 18,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0.95, 0.68),
                  child: FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: _startTracking,
                    tooltip: _isTracking
                        ? 'Stop Tracking'
                        : 'Start Tracking', // Label changes dynamically
                    child: Icon(
                      _isTracking
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
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

  // void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async {
  //   PolylineId id = const PolylineId('poly');
  //   Polyline polyLine = Polyline(
  //       polylineId: id,
  //       color: Colors.red,
  //       points: polylineCoordinates,
  //       width: 5);
  //   setState(() {
  //     polylines[id] = polyLine;
  //   });
  // }

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
