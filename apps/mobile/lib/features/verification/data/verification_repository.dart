import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class VerificationRepository {
  final Dio _dio;

  VerificationRepository({required Dio dio}) : _dio = dio;

  Future<void> start() async {
    await _dio.post<void>(ApiEndpoints.verificationStart);
  }

  Future<void> completeStub(String outcome) async {
    await _dio.post<void>(
      ApiEndpoints.verificationStubComplete,
      data: VerificationStubCompleteDto(outcome: outcome).toMap(),
    );
  }
}
