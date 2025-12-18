import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import '../data/request_repository.dart';

final requestProvider = AsyncNotifierProvider<RequestNotifier, void>(() {
  return RequestNotifier();
});

class RequestNotifier extends AsyncNotifier<void> { // We can change <void> to <List<RequestDto>> later
  @override
  Future<void> build() async {
    // No initial data load yet
  }

  Future<void> createRequest(CreateRequestDto dto) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(requestRepositoryProvider).createRequest(dto);
    });
  }
}
