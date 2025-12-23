import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:models/models.dart';

import '../../../core/api_client_provider.dart';
import '../../../core/listenable_notifier.dart';
import '../data/auth_repository.dart';

// Dependency Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(apiClientProvider);
  return AuthRepository(dio: dio);
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// State
final authProvider = AsyncNotifierProvider<AuthNotifier, UserDto?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<UserDto?> with ListenableNotifier {
  late final AuthRepository _repository;
  late final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';

  @override
  Future<UserDto?> build() async {
    _repository = ref.read(authRepositoryProvider);
    _storage = ref.read(secureStorageProvider);
    return _checkAuth();
  }

  Future<UserDto?> _checkAuth() async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null) {
      try {
        final user = await _repository.getProfile();
        return user;
      } catch (e) {
        // Token invalid or expired
        await logout();
        return null;
      }
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await _repository.login(LoginRequestDto(email: email, password: password));
      await _storage.write(key: _tokenKey, value: response.accessToken);
      return response.user;
    });
  }

  Future<void> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await _repository.register(RegisterRequestDto(email: email, password: password, name: name));
      await _storage.write(key: _tokenKey, value: response.accessToken);
      return response.user;
    });
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    state = const AsyncValue.data(null);
  }
}
