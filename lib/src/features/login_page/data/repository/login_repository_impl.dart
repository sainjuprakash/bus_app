import '../../../../../core/network/dio_client.dart';
import '../../../../../core/network/endpoints.dart';
import '../../../../../core/service/shared_preference_service.dart';
import '../../domain/repository/login_repository.dart';

class ImplLoginRepository extends LoginRepository {
  final DioClient _dioClient = DioClient();
  get http => null;

  @override
  Future<String?> login(String email, String password) async {
    try {
      final response = await _dioClient.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final accessToken = response.data['data']['token'];
        final prefs = await PrefsService.getInstance();
        await prefs.setString(PrefsServiceKeys.accessTokem, accessToken);

        Endpoints.api_token = accessToken;
        // Endpoints.refreshToken = refreshToken;
      } else {
        throw Exception('Failed to login');
      }
    } catch (errMsg) {
      throw Exception("login fail : $errMsg");
    }
  }
}
