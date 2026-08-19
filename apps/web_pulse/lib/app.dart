import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/ui.dart';

import 'router.dart';

class PulseApp extends ConsumerWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(pulseRouterProvider);
    final appTheme = ref.watch(appThemeProvider);

    return TranslationProvider(
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Humanity Pulse',
            locale: TranslationProvider.of(context).flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            theme: AppTheme.build(style: appTheme.style, brightness: Brightness.light),
            darkTheme: AppTheme.build(style: appTheme.style, brightness: Brightness.dark),
            themeMode: appTheme.mode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
