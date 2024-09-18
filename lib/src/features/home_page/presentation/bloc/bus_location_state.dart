part of 'bus_location_bloc.dart';

@immutable
abstract class BusLocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BusLocationLoadingState extends BusLocationState {}

class BusLocationSuccessState extends BusLocationState {
  List<BusLocationModel> busLocationResponse;
  BusLocationSuccessState(this.busLocationResponse);
}

class BusLocationFailureState extends BusLocationState {
  String? errMsg;
  BusLocationFailureState(this.errMsg);
}
