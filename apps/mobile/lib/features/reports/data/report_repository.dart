import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

import '../../../core/network/dio_provider.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(ref.watch(dioProvider));
});

class ReportRepository {
  final Dio _dio;

  ReportRepository(this._dio);

  Future<ReportDto> create(CreateReportDto dto) async {
    final response = await _dio.post<Map<String, dynamic>>(ApiEndpoints.reports, data: dto.toMap());
    return ReportDtoMapper.fromMap(response.data!);
  }

  Future<List<ReportDto>> mine() async {
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.reportsMine);
    final list = response.data ?? [];
    return [for (final item in list) if (item is Map<String, dynamic>) ReportDtoMapper.fromMap(item)];
  }
}
