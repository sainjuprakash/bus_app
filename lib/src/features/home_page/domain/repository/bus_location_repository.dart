import '../../data/model/bus_location.dart';

abstract class BusLocationRepository {
  Future<List<BusLocationModel>> getBusLocation(List<DateTime> dateTime);
}
