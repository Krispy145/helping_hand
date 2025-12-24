import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/listenable_notifier.dart';
import '../../../core/shared_preferences_provider.dart';

// AsyncNotifier to track if onboarding is seen
final onboardingCompletedProvider = AsyncNotifierProvider<OnboardingCompletedNotifier, bool>(() {
  return OnboardingCompletedNotifier();
});

class OnboardingCompletedNotifier extends AsyncNotifier<bool> with ListenableNotifier<bool> {
  static const _keyCompleted = 'onboarding_seen';
  static const _keySteps = 'onboarding_seen_steps';

  @override
  Future<bool> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(_keyCompleted) ?? false;
  }

  Future<void> completeOnboarding() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyCompleted, true);
    state = const AsyncValue.data(true);
  }

  /// Skips onboarding for this session only. Does NOT persist completion.
  Future<void> skipSession() async {
    state = const AsyncValue.data(true);
  }

  Future<void> markStepSeen(String stepName) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final seen = prefs.getStringList(_keySteps) ?? [];
    if (!seen.contains(stepName)) {
      await prefs.setStringList(_keySteps, [...seen, stepName]);
    }
  }

  List<String> getSeenSteps() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getStringList(_keySteps) ?? [];
  }

  /// Resets onboarding state (e.g. on logout)
  Future<void> reset() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_keyCompleted);
    await prefs.remove(_keySteps);
    state = const AsyncValue.data(false);
  }
}
