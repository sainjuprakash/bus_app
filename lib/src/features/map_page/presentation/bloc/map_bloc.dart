import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc()
      : super(const MapTrackingState(
            polylinePoints: [],
            elapsedTime: Duration.zero,
            isTracking: false)) {
    on<StartTrackingEvent>(_onStartTracking);
    on<StopTrackingEvent>(_onStopTracking);
    on<AddPolylinePointEvent>(_onAddPolylinePoint);
    on<UpdateElapsedTimeEvent>(_onUpdateElapsedTime);
  }

  void _onStartTracking(StartTrackingEvent event, Emitter<MapState> emit) {
    final currentState = state as MapTrackingState;
    emit(currentState.copyWith(isTracking: true));
  }

  void _onStopTracking(StopTrackingEvent event, Emitter<MapState> emit) {
    final currentState = state as MapTrackingState;
    emit(currentState.copyWith(isTracking: false));
  }

  void _onAddPolylinePoint(
      AddPolylinePointEvent event, Emitter<MapState> emit) {
    final currentState = state as MapTrackingState;
    final updatedPoints = List<LatLng>.from(currentState.polylinePoints)
      ..add(event.point);
    emit(currentState.copyWith(polylinePoints: updatedPoints));
  }

  void _onUpdateElapsedTime(
      UpdateElapsedTimeEvent event, Emitter<MapState> emit) {
    final currentState = state as MapTrackingState;
    emit(currentState.copyWith(elapsedTime: event.elapsedTime));
  }
}
