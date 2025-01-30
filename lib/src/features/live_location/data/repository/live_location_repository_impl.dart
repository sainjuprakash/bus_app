import 'package:bus_app/src/features/live_location/domain/repository/live_location_repository.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/service/shared_preference_service.dart';

class LiveLocationImpl extends LiveLocation {
  final DioClient _dioClient = DioClient();

  @override
  Future<LatLng> getLiveLocation() async {
    try {
      final _prefs = await PrefsService.getInstance();
      final int? busId = _prefs.getInt(PrefsServiceKeys.busId);
      final response = await _dioClient.post(
        '/get-location-by-date',
        data: {'bus_id': busId, 'date': "2025/01/23"},
      );
      if (response.statusCode == 200) {
        List<dynamic> fetchedData = response.data['data'];
        final firstData = fetchedData[0];
        final double latitude = double.parse(firstData['latitude'].toString());
        final double longitude =
            double.parse(firstData['longitude'].toString());
        return LatLng(latitude, longitude);
      }
    } catch (errMsg) {
      throw UnimplementedError(errMsg.toString());
    }
    throw UnimplementedError();
  }
}
