import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:utils/utils.dart';

import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/chat/presentation/chat_screen.dart';
import 'features/chat/presentation/chats_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/onboarding/application/onboarding_state_provider.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/reports/presentation/report_entry.dart';
import 'features/reports/presentation/report_screen.dart';
import 'features/requests/presentation/create_request_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/verification/presentation/verification_screen.dart';

class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const createRequest = '/create-request';
  static const session = '/session/:id';
  static const onboarding = '/onboarding';
  static const settings = '/settings';
  static const verification = '/verification';
  static const chats = '/chats';
  static const report = '/report';
}

class AppRouter {
  AppRouter._();
  static final instance = AppRouter._();

  // Provider for initial location, can be overridden
  final initialLocationProvider = Provider<String>((ref) => AppRoutes.login);

  // Defines the router provider
  late final routerProvider = Provider<GoRouter>((ref) {
    final initialLoc = ref.watch(initialLocationProvider);
    final refresh = ValueNotifier<int>(0);
    ref.onDispose(refresh.dispose);
    ref.listen(authProvider, (_, __) => refresh.value++);
    ref.listen(onboardingCompletedProvider, (_, __) => refresh.value++);

    return GoRouter(
      initialLocation: initialLoc,
      observers: [LoggingNavigatorObserver()],
      refreshListenable: refresh,
      redirect: (context, state) async {
        final authState = ref.read(authProvider);
        final onboardingState = ref.read(onboardingCompletedProvider);

        // If loading, maybe show splash? Or null to stay put.
        if (authState.isLoading || onboardingState.isLoading) return null;

        final isLoggedIn = authState.asData?.value != null;
        final isOnboarded = onboardingState.asData?.value ?? false;

        final isLoggingIn = state.uri.toString() == AppRoutes.login || state.uri.toString() == AppRoutes.register;
        final isOnboarding = state.uri.toString() == AppRoutes.onboarding;

        // 1. Not Logged In
        if (!isLoggedIn) {
          return isLoggingIn ? null : AppRoutes.login;
        }

        // 2. Logged In, But Not Onboarded
        if (isLoggedIn && !isOnboarded) {
          return isOnboarding ? null : AppRoutes.onboarding;
        }

        // 3. Logged In & Onboarded
        if (isLoggedIn && isOnboarded) {
          // Prevent going back to login/onboarding
          if (isLoggingIn || isOnboarding) return AppRoutes.home;
          return null;
        }

        return null;
      },
      routes: [
        GoRoute(path: AppRoutes.onboarding, builder: (context, state) => const OnboardingScreen()),
        GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
        GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
        GoRoute(path: AppRoutes.register, builder: (context, state) => const RegisterScreen()),
        GoRoute(path: AppRoutes.createRequest, builder: (context, state) => const CreateRequestScreen()),
        GoRoute(
          path: AppRoutes.session,
          builder: (context, state) => ChatScreen(sessionId: state.pathParameters['id']!),
        ),
        GoRoute(path: AppRoutes.settings, builder: (context, state) => const SettingsScreen()),
        GoRoute(path: AppRoutes.verification, builder: (context, state) => const VerificationScreen()),
        GoRoute(path: AppRoutes.chats, builder: (context, state) => const ChatsScreen()),
        GoRoute(
          path: AppRoutes.report,
          builder: (context, state) {
            final extra = state.extra;
            final entry = extra is ReportEntry ? extra : const ReportEntry();
            return ReportScreen(entry: entry);
          },
        ),
      ],
    );
  });
}
