import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../flavors.dart';
import '../features/auth/providers/auth_provider.dart';

// Provider for the base Dio client with interceptors
final apiClientProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: F.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add Auth Token
        final token = await storage.read(key: 'auth_token'); // Hardcoded key matching AuthNotifier
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        // Handle 401 Unauthorized -> Logout
        if (e.response?.statusCode == 401) {
          // We can't use ref.read(authProvider.notifier) here easily because of circular dependency risk if not careful.
          // But since authProvider depends on repository which depends on this, we might have a cycle if we read authProvider here.
          // Ideally, we should perform a side-effect or just let the error propagate and let AuthNotifier catch it.
          // AuthNotifier._checkAuth catches errors.

          // However, for *subsequent* requests (after login), if we get 401, we want to logout.
          // We can use a stream or a separate controller for "AuthEvents".
          // For now, let's just propagate the error. The UI or specific calls should handle it,
          // OR we specifically clear storage here?
          // await storage.delete(key: 'auth_token'); // maybe too aggressive if it's just a flake?
          // 401 usually means token expired/invalid.
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
});
