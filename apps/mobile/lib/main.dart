import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/ui.dart';
import 'package:utils/utils.dart';

import 'app.dart';
import 'core/app_observer.dart';
import 'core/shared_preferences_provider.dart';
import 'core/storage/logging_shared_preferences.dart';
import 'flavors.dart';
import 'router.dart';

// Use --dart-define=FLAVOR=dev
const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.values.firstWhere((element) => element.name == flavorName, orElse: () => Flavor.dev);
  AppLogger.initialize();
  AppLogger.info('App initialized with flavor: ${F.name}');

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

  runApp(
    TranslationProvider(
      child: ProviderScope(
        observers: [AppObserver()],
        overrides: [
          AppRouter.instance.initialLocationProvider.overrideWithValue(hasSeenOnboarding ? AppRoutes.login : AppRoutes.onboarding),
          sharedPreferencesProvider.overrideWithValue(LoggingSharedPreferences(prefs)),
        ],
        child: const App(),
      ),
    ),
  );
}
