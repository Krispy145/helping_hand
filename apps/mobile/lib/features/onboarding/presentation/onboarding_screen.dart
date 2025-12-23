import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import 'onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _finishOnboarding() async {
    await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/login');
    }
  }

  Future<void> _requestLocation() async {
    await ref.read(onboardingControllerProvider.notifier).requestLocationPermission();
    _nextPage();
  }

  Future<void> _requestNotifications() async {
    await ref.read(onboardingControllerProvider.notifier).requestNotificationPermission();
    _nextPage();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    final pages = [
      (title: t.strings.onboarding.welcome.title, description: t.strings.onboarding.welcome.description, icon: Icons.volunteer_activism, onAction: null, actionLabel: null),
      (title: t.strings.onboarding.community.title, description: t.strings.onboarding.community.description, icon: Icons.spa, onAction: null, actionLabel: null),
      (
        title: t.strings.onboarding.location.title,
        description: t.strings.onboarding.location.description,
        icon: Icons.location_on,
        onAction: _requestLocation,
        actionLabel: t.strings.onboarding.location.button,
      ),
      (
        title: t.strings.onboarding.notifications.title,
        description: t.strings.onboarding.notifications.description,
        icon: Icons.notifications_active,
        onAction: _requestNotifications,
        actionLabel: t.strings.onboarding.notifications.button,
      ),
    ];

    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
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
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(color: context.surface, shape: BoxShape.circle),
                          child: Icon(page.icon, size: 80, color: context.primary),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          page.title,
                          style: context.h2.copyWith(color: context.primary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          style: context.bodyLarge.copyWith(color: context.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        if (page.actionLabel != null) ...[
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(onPressed: page.onAction, child: Text(page.actionLabel!)),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _nextPage,
                            child: Text(t.strings.common.cancel, style: TextStyle(color: context.textSecondary)),
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
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: _currentPage == index ? context.primary : context.secondary),
                      ),
                    ),
                  ),
                  if (pages[_currentPage].actionLabel == null)
                    ElevatedButton(onPressed: _nextPage, child: Text(_currentPage < pages.length - 1 ? t.strings.onboarding.next : t.strings.onboarding.getStarted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
