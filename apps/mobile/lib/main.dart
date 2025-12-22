import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utils/utils.dart';

import 'app.dart';
import 'core/app_observer.dart';
import 'flavors.dart';

// Use --dart-define=FLAVOR=dev
const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

void main() {
  F.appFlavor = Flavor.values.firstWhere((element) => element.name == flavorName, orElse: () => Flavor.dev);
  AppLogger.initialize();
  AppLogger.info('App initialized with flavor: ${F.name}');

  runApp(ProviderScope(observers: [AppObserver()], child: const App()));
}
