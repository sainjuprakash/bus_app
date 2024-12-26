import 'dart:async';
import 'package:bus_app/core/service/shared_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:workmanager/workmanager.dart';
import '../../../../constant/map_layers.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import '../../../home_page/data/model/bus_location.dart';
import '../../domain/repository/map_page_repository.dart';

enum MapType { google, osm, satellite }

class MapPage extends StatefulWidget {
  List<BusLocationModel>? busLocationModel;
  final MapRepository mapRepository;
  MapPage({required this.mapRepository, this.busLocationModel, super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapType _currentMapType = MapType.google;
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
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
  Duration _elapsedTime = Duration.zero;
  Timer? _elapsedTimeTimer;
  bool _isTracking = false; // To control location tracking

  @override
  void initState() {
    // print('------------------------');
    // print(widget.busLocationModel);
    super.initState();
    WakelockPlus.enable();
    getDataFromSharedPrefs();
    getLocationUpdates(); //  get location updates but don't generate circles until tracking starts
  }

  // Start tracking location when button is pressed
  void _startTracking() {
    if (!_isTracking) {
      setState(() {
        _isTracking = true;
        _elapsedTime = Duration.zero;
      });
      _startTimer();
      _startElapsedTimeTimer(); // Start the periodic task
    } else {
      setState(() {
        _isTracking = false;
      });
      _timer?.cancel();
      _elapsedTimeTimer?.cancel(); // Stop the periodic task
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

  void _startElapsedTimeTimer() {
    _elapsedTimeTimer?.cancel(); // Cancel any existing timer
    _elapsedTimeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedTime =
            _elapsedTime + const Duration(seconds: 1); // Increment elapsed time
      });
    });
  }

  String _formatElapsedTime() {
    final hour = _elapsedTime.inHours.remainder(60).toString().padLeft(2, '0');
    final minutes =
        _elapsedTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _elapsedTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hour:$minutes:$seconds";
  }

  Future<void> getDataFromSharedPrefs() async {
    final _prefs = await PrefsService.getInstance();
    bearerToken = _prefs.getString(PrefsServiceKeys.accessTokem);
    busId = _prefs.getInt(PrefsServiceKeys.busId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 5,
          title: Center(
            child: Container(
              height: MediaQuery.of(context).size.width / 11,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.surface),
              child: Center(
                child: Text(
                  _isTracking ? _formatElapsedTime() : "Status : Not Tracking",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 15),
                ),
              ),
            ),
          )),
      body: currentP == null
          ? const Center(child: Text('Loading...'))
          : Stack(
              children: [
                if (_currentMapType == MapType.google)
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
                  )
                else
                  flutterMap.FlutterMap(
                    options: flutterMap.MapOptions(
                      initialCenter: LatLong.LatLng(
                          currentP!.latitude, currentP!.longitude),
                      initialZoom: currentZoom,
                      interactionOptions: const flutterMap.InteractionOptions(
                        flags: flutterMap.InteractiveFlag.pinchZoom |
                            flutterMap.InteractiveFlag.drag,
                      ),
                    ),
                    children: [
                      if (_currentMapType == MapType.satellite)
                        TileLayers.satelliteTileLayer,
                      if (_currentMapType == MapType.osm)
                        TileLayers.openStreetMapTileLayer,
                    ],
                  ),
                Align(
                  alignment: const Alignment(-0.98, -0.75),
                  child: Container(
                    height: 100,
                    width: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.7)),
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (_currentMapType == MapType.google) {
                                  _currentMapType = MapType.satellite;
                                } else {
                                  _currentMapType = MapType.google;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.satellite_alt,
                              color: _currentMapType == MapType.satellite
                                  ? Colors.green
                                  : Colors.black,
                            )),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (_currentMapType == MapType.google) {
                                  _currentMapType = MapType.osm;
                                } else {
                                  _currentMapType = MapType.google;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.map_outlined,
                              color: _currentMapType == MapType.osm
                                  ? Colors.green
                                  : Colors.black,
                            ))
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, -0.99),
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
                  alignment: const Alignment(1, -0.78),
                  child: Container(
                    height: 50,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                Align(
                  alignment: const Alignment(0.95, -0.77),
                  child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () {
                        _startTracking();
                      },
                      icon: Icon(
                        _isTracking ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            _isTracking ? Colors.red : Colors.green,
                        padding: const EdgeInsets.all(8),
                        elevation: 4,
                      ),
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.05,
                  minChildSize: 0.05,
                  maxChildSize: 0.6,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        boxShadow: const [
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
                            height: 8,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface,
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
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                      child: Text(
                                        _isTracking
                                            ? 'Stop Tracking'
                                            : 'Start Tracking',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface),
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
