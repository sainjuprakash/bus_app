import 'package:bus_app/src/features/home_page/data/model/bus_location_response.dart';

abstract class BusLocationRepository {
  Future<BusLocationResponse> getBusLocation();
}
