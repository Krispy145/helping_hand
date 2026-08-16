import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/ui.dart';
import 'package:utils/utils.dart';

import 'app.dart';
import 'core/shared_preferences_provider.dart';
import 'core/storage/logging_shared_preferences.dart';
import 'flavors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.values.firstWhere((element) => element.name == appFlavor, orElse: () => Flavor.dev);
  AppLogger.initialize();
  LocaleSettings.useDeviceLocaleSync();

  final prefs = LoggingSharedPreferences(await SharedPreferences.getInstance());

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWith((ref) => prefs)],
      child: const App(),
    ),
  );
}
