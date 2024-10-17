import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('--- Request ---');
    debugPrint('Method: ${options.method}');
    debugPrint('URL: ${options.uri}');
    debugPrint('Headers: ${options.headers}');
    debugPrint('Body: ${jsonEncode(options.data)}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('--- Response ---');
    debugPrint('URL: ${response.requestOptions.uri}');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Data: ${jsonEncode(response.data)}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('--- Error ---');
    debugPrint('URL: ${err.requestOptions.uri}');
    debugPrint('Error: ${err.message}');
    super.onError(err, handler);
  }
}
