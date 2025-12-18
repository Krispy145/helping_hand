import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:utils/utils.dart';

import '../../flavors.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: F.apiBaseUrl, contentType: Headers.jsonContentType));

  // Add Auth & Logger Interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        AppLogger.info('--> ${options.method.toUpperCase()} ${options.path}', extras: {'query': options.queryParameters, 'data': options.data});

        // Add Auth Token
        const storage = FlutterSecureStorage();
        final token = await storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        AppLogger.info('<-- ${response.statusCode} ${response.requestOptions.path}');
        // Optional: Log data at debug level
        AppLogger.debug('Response Data:', extras: {'data': response.data});
        return handler.next(response);
      },
      onError: (e, handler) {
        AppLogger.error('<-- ERROR ${e.response?.statusCode} ${e.requestOptions.path}', error: e, stackTrace: e.stackTrace, extras: {'message': e.message, 'type': e.type.toString()});
        return handler.next(e);
      },
    ),
  );

  return dio;
});
