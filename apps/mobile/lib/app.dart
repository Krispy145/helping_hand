import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/ui.dart';
import 'package:utils/utils.dart';

import 'flavors.dart';
import 'router.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final AppLifecycleObserver _lifecycleObserver;

  @override
  void initState() {
    super.initState();
    _lifecycleObserver = AppLifecycleObserver();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(AppRouter.instance.routerProvider);
    final appTheme = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: F.title,
      theme: AppTheme.build(style: appTheme.style, brightness: Brightness.light),
      darkTheme: AppTheme.build(style: appTheme.style, brightness: Brightness.dark),
      themeMode: appTheme.mode,
      routerConfig: router,
      builder: (context, child) => _flavorBanner(child: child ?? const SizedBox.shrink()),
    );
  }

  Widget _flavorBanner({required Widget child, bool show = true}) {
    if (!show) return child;

    return Builder(
      builder: (context) {
        return Banner(
          location: BannerLocation.topStart,
          message: F.name,
          color: context.tertiary.withValues(alpha: 0.6), // Use tertiary (softer) for flavor banner
          textStyle: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w700, letterSpacing: 1, color: context.onTertiary),
          textDirection: TextDirection.ltr,
          child: child,
        );
      },
    );
  }
}
