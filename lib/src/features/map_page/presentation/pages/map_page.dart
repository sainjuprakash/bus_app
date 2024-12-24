import 'dart:async';
import 'package:bus_app/core/service/shared_preference_service.dart';
import 'package:bus_app/src/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:workmanager/workmanager.dart';

import '../../../home_page/data/model/bus_location.dart';
import '../../domain/repository/map_page_repository.dart';

class MapPage extends StatefulWidget {
  List<BusLocationModel>? busLocationModel;
  final MapRepository mapRepository;
  MapPage({required this.mapRepository, this.busLocationModel, super.key});

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
  int selectedNumber = 10;
  final int minNumber = 5;
  final int maxNumber = 120; // You can adjust this as needed

  bool _isTracking = false; // To control location tracking

  @override
  void initState() {
    // print('------------------------');
    // print(widget.busLocationModel);
    super.initState();
    WakelockPlus.enable();
    getDataFromSharedPrefs();
    getLocationUpdates(); // We get location updates but don't generate circles until tracking starts
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
        widget.mapRepository.sendLocation(
            position: currentP!, bearerToken: bearerToken!, busId: busId!);

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
                  alignment: Alignment(0, -0.9),
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
                DraggableScrollableSheet(
                  initialChildSize: 0.05,
                  minChildSize: 0.05,
                  maxChildSize: 0.6,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 8),
                            height: 5,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              controller: scrollController,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _startTracking();
                                      },
                                      child: Text(
                                        _isTracking
                                            ? 'Stop Tracking'
                                            : 'Start Tracking',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
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

  // Future<List<LatLng>> getPolylinePoints() async {
  //   List<LatLng> polylineCoordinate = [];
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     request: PolylineRequest(
  //       origin: PointLatLng(_pGooglePxl.latitude, _pGooglePxl.longitude),
  //       destination: PointLatLng(_destination.latitude, _destination.longitude),
  //       mode: TravelMode.driving,
  //     ),
  //     googleApiKey: GOOGLE_API_KEY,
  //   );
  //   if (result.points.isNotEmpty) {
  //     for (var point in result.points) {
  //       polylineCoordinate.add(LatLng(point.latitude, point.longitude));
  //     }
  //   } else {
  //     print(result.errorMessage);
  //   }
  //   return polylineCoordinate;
  // }

  void generateCirclesFromPoints(List<LatLng> polylineCoordinates) async {
    Set<Circle> newCircles = {};
    for (int i = 0; i < polylineCoordinates.length; i++) {
      newCircles.add(Circle(
        circleId: CircleId('circle_$i'),
        center: polylineCoordinates[i],
        radius: 3,
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
    _timer?.cancel();
    super.dispose();
  }
}
