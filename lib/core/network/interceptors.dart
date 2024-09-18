/**
 * Copyright (c) 2024
 * Created by Mahesh Yakami on 5/7/24.
 *
 * yakami.mahesh@gmail.com
 */

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../service/shared_preference_service.dart';
import 'endpoints.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {
  Logger logger =
      Logger(printer: PrettyPrinter(methodCount: 0, printTime: true));

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e('${options.method} request ==> $requestPath'); //Error log
    logger.d('Error type: ${err.error} \n '
        'Error message: ${err.message}'); //Debug log
    handler.next(err); //Continue with the Error
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('${options.method} request ==> $requestPath'); //Info log
    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('STATUSCODE: ${response.statusCode} \n '
        'STATUSMESSAGE: ${response.statusMessage} \n'
        'HEADERS: ${response.headers} \n'
        'Data: ${response.data}'); // Debug log
    handler.next(response); // continue with the Response
  }
}

/// This interceptor intercepts GET request and add "Authorization" header
/// and then, send it to the [API]
class AuthorizationInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (_needAuthorizationHeader(options)) {
// adds the access-token with the header
      final prefs = await PrefsService.getInstance();
      final String? token = prefs.getString(PrefsServiceKeys.accessTokem);
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options); // continue with the request
  }

  bool _needAuthorizationHeader(RequestOptions options) {
    if (options.method == 'GET' || options.method == 'POST') {
      return true;
    }
    return false;
  }
}
