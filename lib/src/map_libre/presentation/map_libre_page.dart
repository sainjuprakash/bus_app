import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import 'package:maplibre_gl/maplibre_gl.dart';

class MapLibreExample extends StatefulWidget {
  const MapLibreExample({super.key});

  @override
  _MapLibreExampleState createState() => _MapLibreExampleState();
}

class _MapLibreExampleState extends State<MapLibreExample> {
  late MapLibreMapController mapController;

  // Add your custom style URL (self-hosted or from a provider like MapTiler)
  final String mapStyleUrl =
      "https://api.maptiler.com/maps/streets/style.json?key=K1MrUpxtHuXh6mK7E6fK";

  String _selectedValue = 'MapLibre'; // Default is MapLibre

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
    print("MapLibre Map created!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location History"),
        actions: [
          DropdownButton<String>(
            value: _selectedValue,
            dropdownColor: Colors.black,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'MapLibre', child: Text("MapLibre")),
              DropdownMenuItem(value: 'OSM', child: Text("OpenStreetMap")),
              DropdownMenuItem(value: 'Satellite', child: Text("Satellite")),
            ],
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_selectedValue == 'MapLibre')
            MapLibreMap(
              styleString: mapStyleUrl,
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(27.7000, 85.3333),
                zoom: 14.0,
              ),
            )
          else
            FlutterMap(
              options: const MapOptions(
                initialCenter: LatLong.LatLng(27.71, 85.42),
                initialZoom: 15,
                interactionOptions: InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                _selectedValue == 'OSM'
                    ? openStreetMapTileLayer
                    : satelliteTileLayer,
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching),
        onPressed: () {
          if (_selectedValue == 'MapLibre') {
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                const CameraPosition(
                  target:
                      LatLng(27.7000, 85.3333), // Move camera to a new location
                  zoom: 18.0,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text("Location animation is only available for MapLibre."),
              ),
            );
          }
        },
      ),
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleflet.flutter_map.example',
    );

TileLayer get satelliteTileLayer => TileLayer(
      urlTemplate:
          'http://www.google.cn/maps/vt?lyrs=s@189&gl=cn&x={x}&y={y}&z={z}',
      userAgentPackageName: 'dev.fleflet.flutter_map.example',
    );
