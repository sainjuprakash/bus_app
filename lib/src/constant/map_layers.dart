import 'package:flutter_map/flutter_map.dart';

class TileLayers {
  static TileLayer openStreetMapTileLayer = TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'dev.fleflet.flutter_map.example',
  );

  static TileLayer satelliteTileLayer = TileLayer(
    urlTemplate:
        'http://www.google.cn/maps/vt?lyrs=s@189&gl=cn&x={x}&y={y}&z={z}',
    userAgentPackageName: 'dev.fleflet.flutter_map.example',
  );

  static TileLayer mapLibreTileLayer = TileLayer(
    urlTemplate:
        'https://api.maptiler.com/maps/streets/style.json?key=K1MrUpxtHuXh6mK7E6fK',
    userAgentPackageName: 'dev.fleflet.flutter_map.example',
  );
}
