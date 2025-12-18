
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'flavors.dart';

// Use --dart-define=FLAVOR=dev
const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

void main() {
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == flavorName,
    orElse: () => Flavor.dev,
  );

  runApp(const ProviderScope(child: App()));
}
