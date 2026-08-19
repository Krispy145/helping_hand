import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:models/models.dart';

import '../../../core/api_client_provider.dart';
import '../../../core/listenable_notifier.dart';
import '../../../core/shared_preferences_provider.dart';
import '../../../core/storage/logging_secure_storage.dart';
import '../../notifications/data/device_token_repository.dart';
import '../../onboarding/application/onboarding_state_provider.dart';
import '../data/auth_repository.dart';
import '../presentation/widgets/profile_avatar.dart';

// Dependency Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(apiClientProvider);
  return AuthRepository(dio: dio);
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const LoggingSecureStorage();
});

// State
final authProvider = AsyncNotifierProvider<AuthNotifier, UserDto?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<UserDto?> with ListenableNotifier {
  late final AuthRepository _repository;
  late final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  @override
  Future<UserDto?> build() async {
    _repository = ref.read(authRepositoryProvider);
    _storage = ref.read(secureStorageProvider);
    return _restoreSession();
  }

  Future<UserDto?> _restoreSession() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null || token.isEmpty) return null;

    try {
      final user = await _repository.getProfile();
      await _cacheUser(user);
      unawaited(ref.read(deviceTokenRepositoryProvider).sync());
      return user;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await _clearAuthStorage();
        return null;
      }
      return _readCachedUser();
    } catch (_) {
      return _readCachedUser();
    }
  }

  Future<UserDto?> _readCachedUser() async {
    final raw = await _storage.read(key: _userKey);
    if (raw == null) return null;
    try {
      return UserDtoMapper.fromJson(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> _cacheUser(UserDto user) async {
    await _storage.write(key: _userKey, value: user.toJson());
  }

  Future<void> _persistSession(AuthResponseDto response) async {
    await _storage.write(key: _tokenKey, value: response.accessToken);
    await _cacheUser(response.user);
  }

  Future<void> _clearAuthStorage() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await _repository.login(LoginRequestDto(email: email, password: password));
      await _persistSession(response);
      unawaited(ref.read(deviceTokenRepositoryProvider).sync());
      return response.user;
    });
  }

  Future<void> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await _repository.register(RegisterRequestDto(email: email, password: password, name: name));
      await _persistSession(response);
      unawaited(ref.read(deviceTokenRepositoryProvider).sync());
      return response.user;
    });
  }

  Future<void> refreshProfile() async {
    final user = await _repository.getProfile();
    await _cacheUser(user);
    state = AsyncValue.data(user);
  }

  Future<void> logout() async {
    await ref.read(deviceTokenRepositoryProvider).clear();
    await _clearAuthStorage();
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(ProfileAvatar.prefKey);
    await ref.read(onboardingCompletedProvider.notifier).reset();
    state = const AsyncValue.data(null);
  }
}
