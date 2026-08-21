import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class VerificationRepository {
  final Dio _dio;

  VerificationRepository({required Dio dio}) : _dio = dio;

  Future<VerificationStatusResponseDto> getStatus() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.verificationStatus,
    );
    return VerificationStatusResponseDtoMapper.fromMap(response.data!);
  }

  Future<EligibilityResultDto> checkEligibility(DateTime dateOfBirth) async {
    final isoDate =
        '${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}';
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.verificationEligibility,
      data: EligibilityCheckDto(dateOfBirth: isoDate).toMap(),
    );
    return EligibilityResultDtoMapper.fromMap(response.data!);
  }

  Future<VerificationStatusResponseDto> start() async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.verificationStart,
    );
    return VerificationStatusResponseDtoMapper.fromMap(response.data!);
  }

  Future<VerificationStatusResponseDto> startDocument() async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.verificationDocument,
    );
    return VerificationStatusResponseDtoMapper.fromMap(response.data!);
  }

  Future<VerificationStatusResponseDto> refresh() async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.verificationRefresh,
    );
    return VerificationStatusResponseDtoMapper.fromMap(response.data!);
  }

  Future<void> completeStub(String outcome) async {
    await _dio.post<void>(
      ApiEndpoints.verificationStubComplete,
      data: VerificationStubCompleteDto(outcome: outcome).toMap(),
    );
  }
}
