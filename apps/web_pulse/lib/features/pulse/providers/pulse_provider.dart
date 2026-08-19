import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';

import '../../../core/api_client_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/pulse_repository.dart';

final pulseRepositoryProvider = Provider<PulseRepository>((ref) {
  return PulseRepository(dio: ref.watch(apiClientProvider));
});

final pulseSummaryProvider = FutureProvider<PulseSummaryDto>((ref) {
  ref.watch(authProvider);
  return ref.watch(pulseRepositoryProvider).summary();
});

final pulseQueueProvider = FutureProvider<List<PulseQueueItemDto>>((ref) {
  ref.watch(authProvider);
  return ref.watch(pulseRepositoryProvider).queue();
});
