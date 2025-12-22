import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:utils/utils.dart';

import '../../../core/network/dio_provider.dart';

final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  return RequestRepository(ref.watch(dioProvider));
});

class RequestRepository {
  final Dio _dio;

  RequestRepository(this._dio);

  Future<RequestDto> createRequest(CreateRequestDto dto) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.requests,
        data: dto.toJson(), // dart_mappable extension
      );
      // Ensure the response data is parsed correctly using MapperContainer if explicit decoding needed,
      // or rely on matching json structure.
      // Assuming response.data is the Map<String, dynamic> of Request object.
      return RequestDtoMapper.fromMap(response.data!);
    } catch (e) {
      // Basic error handling for MVP
      rethrow;
    }
  }

  Future<List<RequestDto>> getNearbyRequests({double lat = 40.7128, double lng = -74.0060, double radius = 10}) async {
    try {
      final response = await _dio.get<List<dynamic>>(ApiEndpoints.requestsNearby, queryParameters: {'lat': lat, 'lng': lng, 'radius': radius});
      final list = response.data!;
      return list.map((e) => RequestDtoMapper.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
