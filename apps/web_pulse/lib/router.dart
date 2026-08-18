import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';

import 'features/auth/presentation/login_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/pulse/presentation/pulse_screen.dart';

class PulseRoutes {
  static const home = '/';
  static const login = '/login';
}

final pulseRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);
  ref.listen(authProvider, (_, __) => refresh.value++);

  return GoRouter(
    initialLocation: PulseRoutes.login,
    refreshListenable: refresh,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      if (authState.isLoading) return null;

      final user = authState.asData?.value;
      final loggingIn = state.uri.path == PulseRoutes.login;
      final isStaff =
          user != null &&
          (user.role == UserRoleDto.ADMIN || user.role == UserRoleDto.MODERATOR);

      if (!isStaff) {
        return loggingIn ? null : PulseRoutes.login;
      }
      if (loggingIn) return PulseRoutes.home;
      return null;
    },
    routes: [
      GoRoute(path: PulseRoutes.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: PulseRoutes.home, builder: (context, state) => const PulseScreen()),
    ],
  );
});
