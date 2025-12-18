import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../flavors.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: F.apiBaseUrl,
    contentType: Headers.jsonContentType,
  ));

  // Add Auth Interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Access storage directly or via a provider if we extracted it
      // For now, simpler to re-instantiate or inject storage.
      // Better: Use the authProvider's state or a dedicated Token provider.
      // But AuthNotifier has the storage instance.
      // Let's instantiate storage here for now as it's cheap.
      const storage = FlutterSecureStorage(); 
      final token = await storage.read(key: 'auth_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ));

  return dio;
});
