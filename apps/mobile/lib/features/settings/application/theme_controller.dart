import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/shared_preferences_provider.dart';

// Simple provider to access SharedPreferences (assuming it's initialized in main)
// Ideally we pass the instance or have a sync provider.
// For now, let's assume we can get it via a FutureProvider or similar,
// BUT since we want to load theme synchronously at startup if possible,
// or asyncly. Let's make ThemeController AsyncNotifier or just Notifier with default and async load.
// Better: initialize SharedPreferences in main and pass to a provider Override.

class ThemeController extends Notifier<ThemeMode> {
  static const _themeKey = 'theme_mode';

  @override
  ThemeMode build() {
    // Initial load from prefs
    try {
      final prefs = ref.watch(sharedPreferencesProvider);
      final savedTheme = prefs.getString(_themeKey);
      if (savedTheme == 'light') return ThemeMode.light;
      if (savedTheme == 'dark') return ThemeMode.dark;
    } catch (_) {
      // If provider not overridden yet or error
    }
    return ThemeMode.system;
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(sharedPreferencesProvider);
    var value = 'system';
    if (mode == ThemeMode.light) value = 'light';
    if (mode == ThemeMode.dark) value = 'dark';
    await prefs.setString(_themeKey, value);
  }
}

final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);
