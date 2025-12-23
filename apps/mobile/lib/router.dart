import 'package:flutter/foundation.dart'; // For Listenable
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:utils/utils.dart';

import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/chat/presentation/chat_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/onboarding/application/onboarding_state_provider.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/requests/presentation/create_request_screen.dart';
import 'features/settings/presentation/settings_screen.dart';

class AppRouter {
  AppRouter._();
  static final instance = AppRouter._();
  final String homeRoute = '/';
  final String loginRoute = '/login';
  final String registerRoute = '/register';
  final String createRequestRoute = '/create-request';
  final String sessionRoute = '/session/:id';

  // Provider for initial location, can be overridden
  final initialLocationProvider = Provider<String>((ref) => '/login');

  // Defines the router provider
  late final routerProvider = Provider<GoRouter>((ref) {
    final initialLoc = ref.watch(initialLocationProvider);
    return GoRouter(
      initialLocation: initialLoc,
      observers: [LoggingNavigatorObserver()],
      refreshListenable: Listenable.merge([ref.read(authProvider.notifier), ref.read(onboardingCompletedProvider.notifier)]),
      redirect: (context, state) async {
        final authState = ref.read(authProvider);
        final onboardingState = ref.read(onboardingCompletedProvider);

        // If loading, maybe show splash? Or null to stay put.
        if (authState.isLoading || onboardingState.isLoading) return null;

        final isLoggedIn = authState.asData?.value != null;
        final isOnboarded = onboardingState.asData?.value ?? false;

        final isLoggingIn = state.uri.toString() == loginRoute || state.uri.toString() == registerRoute;
        final isOnboarding = state.uri.toString() == '/onboarding';

        // 1. Not Logged In
        if (!isLoggedIn) {
          return isLoggingIn ? null : loginRoute;
        }

        // 2. Logged In, But Not Onboarded
        if (isLoggedIn && !isOnboarded) {
          return isOnboarding ? null : '/onboarding';
        }

        // 3. Logged In & Onboarded
        if (isLoggedIn && isOnboarded) {
          // Prevent going back to login/onboarding
          if (isLoggingIn || isOnboarding) return homeRoute;
          return null;
        }

        return null;
      },
      routes: [
        GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
        GoRoute(path: homeRoute, builder: (context, state) => const HomeScreen()),
        GoRoute(path: loginRoute, builder: (context, state) => const LoginScreen()),
        GoRoute(path: registerRoute, builder: (context, state) => const RegisterScreen()),
        GoRoute(path: createRequestRoute, builder: (context, state) => const CreateRequestScreen()),
        GoRoute(
          path: sessionRoute,
          builder: (context, state) => ChatScreen(sessionId: state.pathParameters['id']!),
        ),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      ],
    );
  });
}
