import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LiveLocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LiveLocationInitialState extends LiveLocationState {}

class LiveLocationLoadingState extends LiveLocationState {}

class LiveLocationLoadedState extends LiveLocationState {
  final LatLng latLng;

  LiveLocationLoadedState(this.latLng);

  @override
  List<Object?> get props => [latLng];
}

class LiveLocationErrorState extends LiveLocationState {
  final String message;

  LiveLocationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
