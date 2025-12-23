import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/listenable_notifier.dart';
import '../../../core/shared_preferences_provider.dart';

// AsyncNotifier to track if onboarding is seen
final onboardingCompletedProvider = AsyncNotifierProvider<OnboardingCompletedNotifier, bool>(() {
  return OnboardingCompletedNotifier();
});

class OnboardingCompletedNotifier extends AsyncNotifier<bool> with ListenableNotifier<bool> {
  static const _key = 'onboarding_seen';

  @override
  Future<bool> build() async {
    // We use ref.watch to rebuild if prefs change? Likely not needed for prefs, read is enough.
    // But keeping watch is fine.
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(_key) ?? false;
  }

  Future<void> completeOnboarding() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_key, true);
    state = const AsyncValue.data(true);
  }
}
