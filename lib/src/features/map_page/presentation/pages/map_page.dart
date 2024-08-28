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
  String? bearerToken;
  int? busId;
  int _selectedTime = 10;
  int selectedNumber = 10;
  final int minNumber = 5;
  final int maxNumber = 120; // You can adjust this as neede

  @override
  void initState() {
    super.initState();
    getDataFromSharedPrefs();
    getLocationUpdates().then((_) {
      getPolylinePoints()
          .then((coordinates) => generateCirclesFromPoints(coordinates));
      getLocationUpdates().then((_) => {
            getPolylinePoints().then(
                (coordinates) => {generatePolylineFromPoints(coordinates)})
          });
    });

    // Initialize the timer to update the polyline periodically
    _startTimer();
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
          initialDelay: Duration(seconds: 1),
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
    print('-----------------------------------');
    print(busId.runtimeType);
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
        // Handle successful response
        print('Location sent successfully');
      } else {
        // Handle error response
        print('Failed to send location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending location: $e');
    }
  }

  /*void _showTimerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<int>(
                title: const Text('1 seconds'),
                value: 1,
                groupValue: _selectedTime,
                onChanged: (int? value) {
                  setState(() {
                    _selectedTime = value!;
                    _startTimer();
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<int>(
                title: const Text('5 seconds'),
                value: 5,
                groupValue: _selectedTime,
                onChanged: (int? value) {
                  setState(() {
                    _selectedTime = value!;
                    _startTimer();
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<int>(
                title: const Text('10 seconds'),
                value: 10,
                groupValue: _selectedTime,
                onChanged: (int? value) {
                  setState(() {
                    _selectedTime = value!;
                    _startTimer();
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<int>(
                title: const Text('20 seconds'),
                value: 20,
                groupValue: _selectedTime,
                onChanged: (int? value) {
                  setState(() {
                    _selectedTime = value!;
                    _startTimer();
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<int>(
                title: const Text('30 seconds'),
                value: 30,
                groupValue: _selectedTime,
                onChanged: (int? value) {
                  setState(() {
                    _selectedTime = value!;
                    _startTimer();
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<int>(
                title: const Text('1 minutes'),
                value: 60,
                groupValue: _selectedTime,
                onChanged: (int? value) {
                  setState(() {
                    _selectedTime = value!;
                    _startTimer();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('My Maps'),
      //   backgroundColor: Colors.white,
      // ),
      body: currentP == null
          ? const Center(child: Text('Loading...'))
          : Stack(children: [
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
                            _startTimer();
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
              // Align(
              //   alignment: const Alignment(0.9, 0.6),
              //   child: FloatingActionButton(
              //     onPressed: _showTimerDialog,
              //     tooltip: 'Timer Adjustment',
              //     child: const Icon(Icons.add_location_alt_outlined),
              //   ),
              // )
            ]),
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
