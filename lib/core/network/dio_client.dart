/**
 * Copyright (c) 2024
 * Created by Mahesh Yakami on 5/7/24.
 *
 * yakami.mahesh@gmail.com
 */

import 'package:dio/dio.dart';

import 'endpoints.dart';
import 'interceptors.dart';

/// Provider of [DioClient]
// final dioClientProvider = Provider<DioClient>((ref) {
//   return DioClient();
// });

const String _key = Endpoints.api_key; // Api key must be private

class DioClient {
  late final Dio _dio;
  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }
  DioClient._internal()
      : _dio = Dio(
          BaseOptions(
              baseUrl: Endpoints.loginBaseUrl,
              queryParameters: {'api_key': _key},
              connectTimeout: Endpoints.connectTimeout,
              receiveTimeout: Endpoints.receiveTimeout,
              headers: {'Content-Type': 'application/json; charset=UTF-8'},
              responseType: ResponseType.json,
              validateStatus: (status) {
                if (status == null) {
                  return false;
                }
                if (status == 422) {
                  return true;
                } else {
                  return status >= 200 && status < 300;
                }
              }),
        )..interceptors.addAll([
            AuthorizationInterceptor(),
            LoggerInterceptor(),
          ]);

  // Method to update the base URL
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  // GET METHOD
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError {
      rethrow;
    }
  }

  // POST METHOD
  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT METHOD
  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE METHOD
  Future<dynamic> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
