import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';

import '../data/request_repository.dart';

final nearbyRequestsProvider = AsyncNotifierProvider<NearbyRequestsNotifier, List<RequestDto>>(NearbyRequestsNotifier.new);

class NearbyRequestsNotifier extends AsyncNotifier<List<RequestDto>> {
  NearbyBounds _bounds = NearbyBounds.capeTownViewport;

  NearbyBounds get bounds => _bounds;

  @override
  Future<List<RequestDto>> build() {
    return _load();
  }

  Future<List<RequestDto>> _load() {
    return ref.read(requestRepositoryProvider).getNearbyRequests(_bounds);
  }

  Future<List<RequestDto>> refresh({NearbyBounds? bounds}) async {
    if (bounds != null) _bounds = bounds;
    if (state.asData?.value == null) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(_load);
    return state.asData?.value ?? [];
  }

  void patchStatus(String requestId, RequestStatusDto status) {
    final requests = state.asData?.value;
    if (requests == null) return;

    if (status == RequestStatusDto.COMPLETED || status == RequestStatusDto.CANCELLED) {
      state = AsyncData(requests.where((request) => request.id != requestId).toList());
      return;
    }

    state = AsyncData([
      for (final request in requests)
        if (request.id == requestId) request.copyWith(status: status) else request,
    ]);
  }
}

final requestProvider = AsyncNotifierProvider<RequestNotifier, void>(RequestNotifier.new);

class RequestNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createRequest(CreateRequestDto dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(requestRepositoryProvider).createRequest(dto);
      await ref.read(nearbyRequestsProvider.notifier).refresh();
    });
  }
}
