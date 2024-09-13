part of 'bus_location_bloc.dart';

@immutable
abstract class BusLocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetBusLocationEvent extends BusLocationEvent {}
