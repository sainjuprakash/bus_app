import 'dart:async';
import 'package:bus_app/src/constant/custom_alret_dialogue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../../../../core/service/shared_preference_service.dart';

class ParentsLocationMapPage extends StatefulWidget {
  LocationData? parentsLocation;
  ParentsLocationMapPage({super.key, required this.parentsLocation});

  @override
  State<ParentsLocationMapPage> createState() => _ParentsLocationMapPageState();
}

class _ParentsLocationMapPageState extends State<ParentsLocationMapPage> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    //getShared();
  }

  void getShared() async {
    final prefs = await PrefsService.getInstance();
    print('=============================');
    prefs.getBool(PrefsServiceKeys.parentsLocation as String);
  }

  @override
  Widget build(BuildContext context) {
    final LatLng initialPosition = LatLng(
      widget.parentsLocation!.latitude!,
      widget.parentsLocation!.longitude!,
    );
    return widget.parentsLocation == null
        ? const Text('Loading')
        : Stack(children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              initialCameraPosition:
                  CameraPosition(target: initialPosition, zoom: 18),
              markers: {
                Marker(
                    markerId: const MarkerId('parentsLocation'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: initialPosition),
              },
            ),
            Align(
                alignment: const Alignment(0, 0.95),
                child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomAlertDialogue(
                              title: "Alert",
                              content: "Update your location ?",
                              onConfirm: () {
                                Navigator.of(context).pop();
                              });
                        },
                      );
                    },
                    child: const Text(
                      'Update my Location',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )))
          ]);
  }
}
