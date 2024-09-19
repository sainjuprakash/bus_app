import 'package:bus_app/src/features/home_page/data/model/bus_location_response.dart';
import 'package:bus_app/src/features/home_page/domain/repository/bus_location_repository.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

import '../../../../../core/network/dio_client.dart';
import '../model/bus_location.dart';

class BusLocationRepositoryImpl implements BusLocationRepository {
  final DioClient _dioClient = DioClient();

  @override
  Future<List<BusLocationModel>> getBusLocation(List<DateTime> dateTime) async {
    try {
      // Format the date to 'YYYY-MM-DD'
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime.first);

      final response = await _dioClient.post(
        '/get-location-by-date',
        data: {'bus_id': 2, 'date': formattedDate},
      );
      if (response.statusCode == 200) {
        List<dynamic> fetchedData = response.data['data'];
        return fetchedData.map((e) => BusLocationModel.fromJson(e)).toList();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (errMsg) {
      throw UnimplementedError(errMsg.toString());
    }
  }
}
