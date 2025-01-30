import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class StartTrackingEvent extends MapEvent {}

class StopTrackingEvent extends MapEvent {}

class AddPolylinePointEvent extends MapEvent {
  final LatLng point;

  const AddPolylinePointEvent(this.point);

  @override
  List<Object?> get props => [point];
}

class UpdateElapsedTimeEvent extends MapEvent {
  final Duration elapsedTime;

  const UpdateElapsedTimeEvent(this.elapsedTime);

  @override
  List<Object?> get props => [elapsedTime];
}
