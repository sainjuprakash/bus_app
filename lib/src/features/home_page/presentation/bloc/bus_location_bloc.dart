import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bus_app/src/features/home_page/data/model/bus_location_response.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/model/bus_location.dart';
import '../../domain/repository/bus_location_repository.dart';

part 'bus_location_event.dart';
part 'bus_location_state.dart';

class BusLocationBloc extends Bloc<BusLocationEvent, BusLocationState> {
  BusLocationRepository busLocationRepository;
  List<DateTime> todaysDate;
  BusLocationBloc(this.busLocationRepository, this.todaysDate)
      : super(BusLocationLoadingState()) {
    on<GetBusLocationEvent>((event, emit) async {
      try {
        List<BusLocationModel> fetchedData =
            await busLocationRepository.getBusLocation(todaysDate);
        emit(BusLocationSuccessState(fetchedData));
      } catch (errMsg) {
        print(errMsg.toString());
        emit(BusLocationFailureState(errMsg.toString()));
      }
    });
  }
}
