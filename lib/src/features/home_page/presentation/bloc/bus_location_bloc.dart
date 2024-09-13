import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bus_app/src/features/home_page/data/model/bus_location_response.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'bus_location_event.dart';
part 'bus_location_state.dart';

class BusLocationBloc extends Bloc<BusLocationEvent, BusLocationState> {
  BusLocationBloc() : super(BusLocationLoadingState()) {
    on<GetBusLocationEvent>((event, emit) async {});
  }
}
