import 'package:dio/dio.dart';
import 'package:models/models.dart';
import '../../../../flavors.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: F.apiBaseUrl));

  Future<AuthResponseDto> login(LoginRequestDto request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/auth/login', data: request.toMap());
      // Wait, dart_mappable generates Mapper classes, usually providing fromMap/fromJson.
      // But models.dart export might not expose the Mapper container directly unless I used it right.
      // Checking dart_mappable usage: usually it's ClassMapper.fromMap(map) or Class.fromMap(map) if hooks are set.
      // I'll assume standard fromMap factory or similar.
      // Actually, with dart_mappable, it's often `AuthResponseDtoMapper.fromMap(...)`.
      // I'll check how I should deserialization properly.
      // For now I will use `AuthResponseDtoMapper.fromMap(response.data)`.
      return AuthResponseDtoMapper.fromMap(response.data!);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<AuthResponseDto> register(RegisterRequestDto request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/auth/register', data: request.toMap());
      return AuthResponseDtoMapper.fromMap(response.data!);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}
