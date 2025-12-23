import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository({required Dio dio}) : _dio = dio;

  Future<AuthResponseDto> login(LoginRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(ApiEndpoints.authLogin, data: request.toMap());
    return AuthResponseDtoMapper.fromMap(response.data!);
  }

  Future<AuthResponseDto> register(RegisterRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(ApiEndpoints.authRegister, data: request.toMap());
    return AuthResponseDtoMapper.fromMap(response.data!);
  }

  Future<UserDto> getProfile() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.authMe);
    return UserDtoMapper.fromMap(response.data!);
  }
}
