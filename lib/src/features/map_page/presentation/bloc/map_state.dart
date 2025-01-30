import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitialState extends MapState {}

class MapTrackingState extends MapState {
  final List<LatLng> polylinePoints;
  final Duration elapsedTime;
  final bool isTracking;

  const MapTrackingState({
    required this.polylinePoints,
    required this.elapsedTime,
    required this.isTracking,
  });

  // Add the copyWith method
  MapTrackingState copyWith({
    List<LatLng>? polylinePoints,
    Duration? elapsedTime,
    bool? isTracking,
  }) {
    return MapTrackingState(
      polylinePoints: polylinePoints ?? this.polylinePoints,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      isTracking: isTracking ?? this.isTracking,
    );
  }

  @override
  List<Object?> get props => [polylinePoints, elapsedTime, isTracking];
}
