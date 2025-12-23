import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';

import '../data/request_repository.dart';

// Provider for fetching nearby requests
final nearbyRequestsProvider = FutureProvider.autoDispose.family<List<RequestDto>, ({double lat, double lng, double radius})>((ref, params) async {
  final repository = ref.watch(requestRepositoryProvider);
  // Simulate network latency for "Loading State UI" visibility
  await Future<void>.delayed(const Duration(seconds: 1));

  return repository.getNearbyRequests(lat: params.lat, lng: params.lng, radius: params.radius);
});

final requestProvider = AsyncNotifierProvider<RequestNotifier, void>(() {
  return RequestNotifier();
});

class RequestNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No initial data load yet
  }

  Future<void> createRequest(CreateRequestDto dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(requestRepositoryProvider).createRequest(dto);
      // Invalidate the nearby feed so it refreshes (if user is in range)
      // We don't have the params here easily, so we might just invalidate all or logic later.
      // For now, simple creation.
    });
  }
}
