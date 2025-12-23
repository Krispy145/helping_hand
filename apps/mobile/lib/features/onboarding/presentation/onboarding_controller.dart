import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../application/onboarding_state_provider.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  Future<List<OnboardingStepType>> build() async {
    final notifier = ref.read(onboardingCompletedProvider.notifier);
    final seenSteps = notifier.getSeenSteps();

    // Define all possible logical steps strictly ordered
    final allLogicalSteps = [OnboardingStepType.welcome, OnboardingStepType.community];

    // Conditionally add permission steps if NOT granted
    // Note: We might want to remove them if "seen" even if not granted?
    // User requirement: "if skip for now is pressed... the user has still seen it... further permissions settings ... in settings"
    // So if SEEN, we exclude it from the list.

    if (!await Permission.locationWhenInUse.isGranted) {
      allLogicalSteps.add(OnboardingStepType.location);
    }

    if (!await Permission.notification.isGranted) {
      allLogicalSteps.add(OnboardingStepType.notification);
    }

    // Filter out steps already seen
    final remainingSteps = allLogicalSteps.where((step) => !seenSteps.contains(step.name)).toList();

    // If we have filtered out some steps, and there are still remaining steps, PREPEND "Continue"
    if (seenSteps.isNotEmpty && remainingSteps.isNotEmpty) {
      // Return new list with continue step
      return [OnboardingStepType.continueFlow, ...remainingSteps];
    }

    // If all steps seen but not marked complete (e.g. crashed before final save),
    // maybe just show nothing and complete?
    // For now, if remaining is empty, the UI calls completeOnboarding.

    return remainingSteps;
  }

  Future<void> markStepSeen(OnboardingStepType step) async {
    await ref.read(onboardingCompletedProvider.notifier).markStepSeen(step.name);
  }

  Future<void> skipSession() async {
    await ref.read(onboardingCompletedProvider.notifier).skipSession();
  }

  Future<void> completeOnboarding() async {
    await ref.read(onboardingCompletedProvider.notifier).completeOnboarding();
  }

  Future<void> requestLocationPermission() async {
    await markStepSeen(OnboardingStepType.location);
    final status = await Permission.locationWhenInUse.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> requestNotificationPermission() async {
    await markStepSeen(OnboardingStepType.notification);
    final status = await Permission.notification.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}

enum OnboardingStepType { welcome, community, location, notification, continueFlow }
