import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

class PulseRepository {
  PulseRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<PulseSummaryDto> summary() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.publicPulseSummary,
    );
    return PulseSummaryDtoMapper.fromMap(response.data!);
  }

  Future<List<PulseQueueItemDto>> queue() async {
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.pulseQueue);
    return (response.data ?? const [])
        .map((item) => PulseQueueItemDtoMapper.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> uphold(String appealId) async {
    await _dio.post<void>(ApiEndpoints.pulseUphold(appealId));
  }

  Future<void> overturn(String appealId) async {
    await _dio.post<void>(ApiEndpoints.pulseOverturn(appealId));
  }
}
