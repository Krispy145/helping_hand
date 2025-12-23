import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/shared_preferences_provider.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  void build() {
    // Stateless controller
  }

  Future<void> completeOnboarding() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('onboarding_seen', true);
  }

  Future<void> requestLocationPermission() async {
    await Permission.locationWhenInUse.request();
  }

  Future<void> requestNotificationPermission() async {
    await Permission.notification.request();
  }
}
