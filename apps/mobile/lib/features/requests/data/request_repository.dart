import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

import '../../../core/network/dio_provider.dart';

final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  return RequestRepository(ref.watch(dioProvider));
});

class NearbyBounds {
  final double minLat;
  final double minLng;
  final double maxLat;
  final double maxLng;

  const NearbyBounds({
    required this.minLat,
    required this.minLng,
    required this.maxLat,
    required this.maxLng,
  });

  static const capeTownViewport = NearbyBounds(
    minLat: -33.96,
    minLng: 18.38,
    maxLat: -33.89,
    maxLng: 18.47,
  );

  Map<String, double> toQuery() => {
    'minLat': minLat,
    'minLng': minLng,
    'maxLat': maxLat,
    'maxLng': maxLng,
  };
}

class RequestRepository {
  final Dio _dio;

  RequestRepository(this._dio);

  Future<RequestDto> createRequest(CreateRequestDto dto) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.requests,
        data: dto.toJson(),
      );
      return RequestDtoMapper.fromMap(response.data!);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RequestDto>> getNearbyRequests(NearbyBounds bounds) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.requestsNearby,
        queryParameters: bounds.toQuery(),
      );
      final list = response.data!;
      return list.map((e) => RequestDtoMapper.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
