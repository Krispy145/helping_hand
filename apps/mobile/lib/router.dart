import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/requests/presentation/create_request_screen.dart';

class AppRouter {
  AppRouter._();
  static final instance = AppRouter._();
  final String homeRoute = '/';
  final String loginRoute = '/login';
  final String registerRoute = '/register';
  final String createRequestRoute = '/create-request';

  // Defines the router provider
  late final routerProvider = Provider<GoRouter>((ref) {
    return GoRouter(
      initialLocation: loginRoute, // Start at login for MVP until persistence is full
      routes: [
        GoRoute(path: homeRoute, builder: (context, state) => const HomeScreen()),
        GoRoute(path: loginRoute, builder: (context, state) => const LoginScreen()),
        GoRoute(path: registerRoute, builder: (context, state) => const RegisterScreen()),
        GoRoute(path: createRequestRoute, builder: (context, state) => const CreateRequestScreen()),
      ],
    );
  });
}
