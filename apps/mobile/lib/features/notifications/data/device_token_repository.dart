import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utils/utils.dart';

import '../../../core/api_client_provider.dart';

final devicePushTokenProvider = FutureProvider<String?>((ref) async => null);

final deviceTokenRepositoryProvider = Provider<DeviceTokenRepository>((ref) {
  return DeviceTokenRepository(
    dio: ref.watch(apiClientProvider),
    readToken: () => ref.read(devicePushTokenProvider.future),
  );
});

class DeviceTokenRepository {
  DeviceTokenRepository({required Dio dio, required Future<String?> Function() readToken})
    : _dio = dio,
      _readToken = readToken;

  final Dio _dio;
  final Future<String?> Function() _readToken;

  static String get platformLabel {
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'other';
  }

  Future<void> sync() async {
    final token = await _readToken();
    if (token == null || token.isEmpty) return;
    try {
      await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.notificationDevices,
        data: {'token': token, 'platform': platformLabel},
      );
    } catch (error, stack) {
      AppLogger.error('Could not register device for alerts', error: error, stackTrace: stack);
    }
  }

  Future<void> clear() async {
    final token = await _readToken();
    if (token == null || token.isEmpty) return;
    try {
      await _dio.delete<Map<String, dynamic>>(
        ApiEndpoints.notificationDevices,
        data: {'token': token},
      );
    } catch (error, stack) {
      AppLogger.error('Could not remove device from alerts', error: error, stackTrace: stack);
    }
  }
}
