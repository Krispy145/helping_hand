import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:utils/utils.dart';

import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/chat/presentation/chat_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/requests/presentation/create_request_screen.dart';

class AppRouter {
  AppRouter._();
  static final instance = AppRouter._();
  final String homeRoute = '/';
  final String loginRoute = '/login';
  final String registerRoute = '/register';
  final String createRequestRoute = '/create-request';
  final String sessionRoute = '/session/:id';

  // Defines the router provider
  late final routerProvider = Provider<GoRouter>((ref) {
    return GoRouter(
      initialLocation: loginRoute,
      observers: [LoggingNavigatorObserver()],
      refreshListenable: ref.read(authProvider.notifier),
      redirect: (context, state) {
        final authState = ref.read(authProvider);
        final isLoggedIn = authState.asData?.value != null;
        final isLoggingIn = state.uri.toString() == loginRoute || state.uri.toString() == registerRoute;

        if (!isLoggedIn && !isLoggingIn) return loginRoute;
        if (isLoggedIn && isLoggingIn) return homeRoute;

        return null;
      },
      routes: [
        GoRoute(path: homeRoute, builder: (context, state) => const HomeScreen()),
        GoRoute(path: loginRoute, builder: (context, state) => const LoginScreen()),
        GoRoute(path: registerRoute, builder: (context, state) => const RegisterScreen()),
        GoRoute(path: createRequestRoute, builder: (context, state) => const CreateRequestScreen()),
        GoRoute(
          path: sessionRoute,
          builder: (context, state) => ChatScreen(sessionId: state.pathParameters['id']!),
        ),
      ],
    );
  });
}
