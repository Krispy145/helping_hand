import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';

import '../../../core/api_client_provider.dart';
import '../../../core/shared_preferences_provider.dart';
import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(dio: ref.watch(apiClientProvider));
});

final authProvider = AsyncNotifierProvider<AuthNotifier, UserDto?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<UserDto?> {
  late final AuthRepository _repository;

  @override
  Future<UserDto?> build() {
    _repository = ref.read(authRepositoryProvider);
    return _restoreSession();
  }

  bool _isStaff(UserDto user) {
    return user.role == UserRoleDto.ADMIN || user.role == UserRoleDto.MODERATOR;
  }

  Future<UserDto?> _restoreSession() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final token = prefs.getString(pulseTokenKey);
    if (token == null || token.isEmpty) return null;

    try {
      final user = await _repository.getProfile();
      if (!_isStaff(user)) {
        await _clear();
        return null;
      }
      await prefs.setString(pulseUserKey, user.toJson());
      return user;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await _clear();
        return null;
      }
      return _readCachedUser();
    } catch (_) {
      return _readCachedUser();
    }
  }

  Future<UserDto?> _readCachedUser() async {
    final raw = ref.read(sharedPreferencesProvider).getString(pulseUserKey);
    if (raw == null) return null;
    try {
      final user = UserDtoMapper.fromJson(raw);
      return _isStaff(user) ? user : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _clear() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(pulseTokenKey);
    await prefs.remove(pulseUserKey);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final response = await _repository.login(
        LoginRequestDto(email: email, password: password),
      );
      if (!_isStaff(response.user)) {
        throw const PulseAccessException();
      }
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setString(pulseTokenKey, response.accessToken);
      await prefs.setString(pulseUserKey, response.user.toJson());
      return response.user;
    });
  }

  Future<void> logout() async {
    await _clear();
    state = const AsyncData(null);
  }
}

class PulseAccessException implements Exception {
  const PulseAccessException();

  @override
  String toString() => 'Pulse is for moderators and admins.';
}
