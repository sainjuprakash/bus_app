import 'package:bus_app/src/features/home_page/data/model/bus_location_response.dart';

import '../../data/model/bus_location.dart';

abstract class BusLocationRepository {
  Future<List<BusLocationModel>> getBusLocation();
}
