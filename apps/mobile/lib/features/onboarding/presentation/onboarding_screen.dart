import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../../router.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _skipSession() async {
    await ref.read(onboardingControllerProvider.notifier).skipSession();
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  Future<void> _finishOnboarding() async {
    await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  Future<void> _markCurrentStepSeen(List<OnboardingStepType> steps) async {
    if (_currentPage < steps.length) {
      await ref.read(onboardingControllerProvider.notifier).markStepSeen(steps[_currentPage]);
    }
  }

  void _nextPage(List<OnboardingStepType> steps) {
    // Mark current step as seen before moving on
    _markCurrentStepSeen(steps);

    if (_currentPage < steps.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finishOnboarding();
    }
  }

  // Skip a specific step (e.g. Permission)
  void _skipStep(List<OnboardingStepType> steps) {
    _nextPage(steps);
  }

  Future<void> _handleAction(OnboardingStepType type, List<OnboardingStepType> steps) async {
    final controller = ref.read(onboardingControllerProvider.notifier);
    switch (type) {
      case OnboardingStepType.location:
        await controller.requestLocationPermission();
        break;
      case OnboardingStepType.notification:
        await controller.requestNotificationPermission();
        break;
      case OnboardingStepType.continueFlow:
        // Just move next
        break;
      default:
        break;
    }
    _nextPage(steps);
  }

  @override
  Widget build(BuildContext context) {
    final stepsAsync = ref.watch(onboardingControllerProvider);
    final t = Translations.of(context);

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _skipSession,
            child: Text('Skip', style: context.bodyLarge.copyWith(color: context.primary)),
          ),
        ],
      ),
      body: stepsAsync.when(
        data: (steps) {
          if (steps.isEmpty) {
            // All steps seen!
            WidgetsBinding.instance.addPostFrameCallback((_) => _finishOnboarding());
            return const SizedBox.shrink();
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      final step = steps[index];
                      // Map Step to UI Data
                      final stepData = _getStepData(context, step);
                      final title = stepData.title;
                      final description = stepData.description;
                      final icon = stepData.icon;
                      final actionLabel = stepData.actionLabel;

                      return Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(color: context.surface, shape: BoxShape.circle),
                              child: Icon(icon, size: 80, color: context.primary),
                            ),
                            const SizedBox(height: 48),
                            Text(
                              title,
                              style: context.h2.copyWith(color: context.primary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              description,
                              style: context.bodyLarge.copyWith(color: context.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                            if (actionLabel != null) ...[
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(onPressed: () => _handleAction(step, steps), child: Text(actionLabel)),
                              ),
                              const SizedBox(height: 16),
                              // Don't show "Skip for now" on Continue step
                              if (step != OnboardingStepType.continueFlow)
                                TextButton(
                                  onPressed: () => _skipStep(steps),
                                  child: Text('Skip for now', style: TextStyle(color: context.textSecondary)),
                                ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                          steps.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            width: _currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: _currentPage == index ? context.primary : context.secondary),
                          ),
                        ),
                      ),
                      // If no explicit action (like permission), show Next button
                      if (_getStepData(context, steps[_currentPage]).actionLabel == null)
                        ElevatedButton(onPressed: () => _nextPage(steps), child: Text(_currentPage < steps.length - 1 ? t.strings.onboarding.next : t.strings.onboarding.getStarted)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: BreathingLoader()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  ({String title, String description, IconData icon, String? actionLabel}) _getStepData(BuildContext context, OnboardingStepType step) {
    final t = Translations.of(context);
    switch (step) {
      case OnboardingStepType.welcome:
        return (title: t.strings.onboarding.welcome.title, description: t.strings.onboarding.welcome.description, icon: Icons.volunteer_activism, actionLabel: null);
      case OnboardingStepType.community:
        return (title: t.strings.onboarding.community.title, description: t.strings.onboarding.community.description, icon: Icons.spa, actionLabel: null);
      case OnboardingStepType.location:
        return (title: t.strings.onboarding.location.title, description: t.strings.onboarding.location.description, icon: Icons.location_on, actionLabel: t.strings.onboarding.location.button);
      case OnboardingStepType.notification:
        return (
          title: t.strings.onboarding.notifications.title,
          description: t.strings.onboarding.notifications.description,
          icon: Icons.notifications_active,
          actionLabel: t.strings.onboarding.notifications.button,
        );
      case OnboardingStepType.continueFlow:
        return (title: 'Welcome Back', description: "Let's pick up where you left off.", icon: Icons.history, actionLabel: 'Continue');
    }
  }
}
