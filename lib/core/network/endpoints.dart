/**
 * Copyright (c) 2024
 * Created by Mahesh Yakami on 5/7/24.
 *
 * yakami.mahesh@gmail.com
 */
// ignore_for_file: constant_identifier_names

class Endpoints {
  static String loginBaseUrl = 'https://gps.git.com.np/api/v1';
  static const String login = 'login';
  static const String api_key = '';

  // will save token here for now
  static String? api_token = '';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  static String refreshToken = '';
}
