import 'dart:async';
import 'package:bus_app/app_localization/l10n.dart';
import 'package:bus_app/core/service/shared_preference_service.dart';
import 'package:bus_app/src/constant/custom_alret_dialogue.dart';
import 'package:bus_app/src/features/map_page/presentation/widgets/draggable_sheet_widget.dart';
import 'package:bus_app/src/features/map_page/presentation/widgets/haversian_formula.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:geolocator/geolocator.dart' as geoLocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:workmanager/workmanager.dart';
import '../../../../../core/service/background_service.dart';
import '../../../../../main.dart';
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
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  LatLng? currentP;
  double currentZoom = 18.0;
  List<LatLng> _polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Timer? _timer;
  String? bearerToken;
  Set<Circle> circles = {};
  int? busId;
  String? role;
  int selectedNumber = 10;
  final int minNumber = 5;
  final int maxNumber = 120; // You can adjust this as needed
  Duration _elapsedTime = Duration.zero;
  Timer? _elapsedTimeTimer;
  bool _isTracking = false; // To control location tracking
  geoLocator.Position? _lastPosition;
  double _totalDistance = 0.0; // In meters
  double _currentSpeed = 0.0; // In meters per second
  LatLng? destination = const LatLng(27.6896659, 85.3203204);

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    //_addDestinationCircle();
    widget.mapRepository.getFirstLocation();
    getDataFromSharedPrefs();
    getLocationUpdates(); //  get location updates but don't generate circles until tracking starts
    _startTrackingSpeed();
  }

  void _addDestinationCircle() {
    circles.add(
      Circle(
        circleId: const CircleId("destination"),
        center: destination!,
        radius: 80, // Radius in meters
        fillColor: Colors.blue.withOpacity(0.5),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    );
  }

  // Start tracking location when button is pressed
  Future<void> _startTracking() async {
    final _prefs = await PrefsService.getInstance();
    if (!_isTracking) {
      setState(() {
        _prefs.setBool(PrefsServiceKeys.isTracking, true);
        _isTracking = true;
        _elapsedTime = Duration.zero;
      });
      initializeService();
      _startTimer();
      _startElapsedTimeTimer(); // Start the periodic task
    } else {
      setState(() {
        _prefs.setBool(PrefsServiceKeys.isTracking, false);
        _isTracking = false;
      });
      _timer?.cancel();
      _elapsedTimeTimer?.cancel();
      Workmanager().initialize(callbackDispatcher);
      final LifecycleEventHandler lifecycleEventHandler = LifecycleEventHandler(
        detachedCallBack: () async {
          final service = FlutterBackgroundService();
          service.invoke('stopService');
        },
      );

      WidgetsBinding.instance
          .addObserver(lifecycleEventHandler); // Stop the periodic task
    }
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel the existing timer if any
    _timer = Timer.periodic(Duration(seconds: selectedNumber), (Timer t) {
      if (currentP != null) {
        setState(() {
          _polylineCoordinates.add(currentP!);
          updateCircles(_polylineCoordinates);
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
    role = _prefs.getString(PrefsServiceKeys.role);
  }

  void _startTrackingSpeed() async {
    bool serviceEnabled =
        await geoLocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await geoLocator.Geolocator.openLocationSettings();
      return;
    }

    geoLocator.LocationPermission permission =
        await geoLocator.Geolocator.checkPermission();
    if (permission == geoLocator.LocationPermission.denied) {
      permission = await geoLocator.Geolocator.requestPermission();
      if (permission == geoLocator.LocationPermission.denied) {
        return;
      }
    }
    geoLocator.Geolocator.getPositionStream(
      locationSettings: const geoLocator.LocationSettings(
          distanceFilter:
              1, // Minimum distance (in meters) to trigger an update
          accuracy: geoLocator.LocationAccuracy.high),
    ).listen((geoLocator.Position position) {
      if (_lastPosition != null) {
        final distance = geoLocator.Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        setState(() {
          _totalDistance += distance;
          _currentSpeed = position.speed; // Speed in m/s
        });
      }
      _lastPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: role == 'Driver'
          ? AppBar(
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
                      _isTracking ? _formatElapsedTime() : l10n.status,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 15),
                    ),
                  ),
                ),
              ))
          : null,
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
                      // Marker(
                      //     markerId: const MarkerId('destination'),
                      //     icon: BitmapDescriptor.defaultMarker,
                      //     position: destination!),
                    },
                    circles: circles,
                    // polylines: Set<Polyline>.of(polylines.values),
                    onCameraMove: (CameraPosition position) {
                      currentZoom = position.zoom;
                    },
                  )
                else
                  flutterMap.FlutterMap(
                    options: flutterMap.MapOptions(
                      initialCenter: LatLong.LatLng(
                          currentP!.latitude, currentP!.longitude),
                      initialZoom: 17,
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
                      flutterMap.MarkerLayer(markers: [
                        flutterMap.Marker(
                          height: 20,
                          width: 40,
                          point: LatLong.LatLng(
                              currentP!.latitude, currentP!.longitude),
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 30,
                          ),
                        )
                      ]),
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
                                if (_currentMapType == MapType.google ||
                                    _currentMapType == MapType.osm) {
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
                                if (_currentMapType == MapType.google ||
                                    _currentMapType == MapType.satellite) {
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
                role == 'Driver'
                    ? Align(
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "${number.toString()}s",
                                    style: TextStyle(
                                      fontSize: isSelected ? 24 : 18,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                role == 'Driver'
                    ? Align(
                        alignment: const Alignment(1, -0.78),
                        child: Container(
                          height: 50,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      )
                    : const SizedBox.shrink(),
                role == 'Driver'
                    ? Align(
                        alignment: const Alignment(0.95, -0.77),
                        child: Container(
                          height: 40,
                          width: 40,
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomAlertDialogue(
                                        title: "Tracking Alert",
                                        content: !_isTracking
                                            ? "Start tracking your location ?"
                                            : "Stop tracking your location ?",
                                        onConfirm: () {
                                          _startTracking();
                                        });
                                  });
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
                      )
                    : const SizedBox.shrink(),
                draggableSheet(_totalDistance, _currentSpeed)
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
    final permissionGranted =
        await widget.mapRepository.checkAndRequestPermissions();
    bool _hasShownNotification = false;
    if (!permissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission not granted!')),
      );
      return;
    }
    try {
      final locationStream = widget.mapRepository.getLocationUpdate();
      locationStream.listen((LocationData currentLocation) async {
        if (currentLocation.longitude != null &&
            currentLocation.latitude != null) {
          setState(() {
            currentP =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            _cameraToPosition(currentP!);
          });
          var distanceBetweenSourceAndDes =
              haversineDistance(currentP!, destination!);
          if (distanceBetweenSourceAndDes < 60 &&
              _hasShownNotification == false) {
            setState(() {
              _hasShownNotification = true;
            });
            await widget.mapRepository.sendPushNotification();
          }
        }
      });
    } catch (e) {
      print("Error getting location updates: $e");
    }
  }

  void updateCircles(List<LatLng> points) {
    setState(() {
      circles = widget.mapRepository.generateCirclesFromPoints(points).toSet();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function() detachedCallBack;

  LifecycleEventHandler({required this.detachedCallBack});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      detachedCallBack();
    }
  }
}
