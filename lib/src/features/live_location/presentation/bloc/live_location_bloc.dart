import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import '../../domain/repository/live_location_repository.dart';
import 'live_location_event.dart';
import 'live_location_state.dart';

class LiveLocationBloc extends Bloc<LiveLocationEvent, LiveLocationState> {
  final LiveLocation liveLocation;
  Timer? _timer;
  LiveLocationBloc(this.liveLocation) : super(LiveLocationInitialState()) {
    on<FetchLocationEvent>((event, emit) async {
      emit(LiveLocationLoadingState());
      try {
        final fetchedData = liveLocation.getLiveLocation();
        print('===================================');
        print(fetchedData);
        emit(LiveLocationLoadedState(fetchedData as LatLng));
      } catch (errMsg) {
        emit(LiveLocationErrorState(errMsg.toString()));
      }
    });
  }
  void startFetching() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      add(FetchLocationEvent());
    });
  }

  void stopFetching() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
