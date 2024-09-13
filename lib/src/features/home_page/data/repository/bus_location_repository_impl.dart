import 'package:bus_app/src/features/home_page/data/model/bus_location_response.dart';
import 'package:bus_app/src/features/home_page/domain/repository/bus_location_repository.dart';

import '../../../../../core/network/dio_client.dart';

class BusLocationRepositoryImpl implements BusLocationRepository {
  final DioClient _dioClient = DioClient();

  @override
  Future<BusLocationResponse> getBusLocation() async {
    try {
      final response = await _dioClient.post(
        '/login',
        data: {'bus_id': 2, 'date': '2024-09-12'},
      );
      if (response.statusCode == 200) {
        BusLocationResponse fetchedData = response.data['data'];
        return fetchedData;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (errMsg) {
      throw UnimplementedError(errMsg.toString());
    }
  }
}
