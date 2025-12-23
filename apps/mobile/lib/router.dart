import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:utils/utils.dart';

import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/chat/presentation/chat_screen.dart';
import 'features/home/presentation/home_screen.dart';
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
      refreshListenable: ref.read(authProvider.notifier),
      redirect: (context, state) async {
        final authState = ref.read(authProvider);
        final isLoggedIn = authState.asData?.value != null;
        final isLoggingIn = state.uri.toString() == loginRoute || state.uri.toString() == registerRoute;

        // Onboarding Check
        if (!isLoggedIn && !isLoggingIn) {
          // We can't easily check async shared prefs here in a sync redirect without blocking or pre-loading.
          // For MVP, we can assume if not logged in, we check if we should show onboarding.
          // But simpler pattern: Have a Splash screen that decides.
          // OR: rely on a provider that loads this state.

          // Let's add a simple check in AppRouter or assume we go to login, and Login redirects to Onboarding if needed?
          // Actually, usually app starts at Splash -> Checks Auth & Onboarding -> Redirects.

          // For this step, I will add the route, and I'll modify the redirect to support a basic flow.
          // Ideally we need a 'appStartupProvider'.
        }

        // Simpler implementation for now:
        // We will make the route available. The redirection logic requires an async check which GoRouter
        // handles via a Future, OR we pre-load in main.dart.
        // Let's go with pre-loading in main.dart passed to the App.

        if (!isLoggedIn && !isLoggingIn) return loginRoute;
        if (isLoggedIn && isLoggingIn) return homeRoute;

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
