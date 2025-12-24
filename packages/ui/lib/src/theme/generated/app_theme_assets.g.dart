// GENERATED CODE - DO NOT MODIFY BY HAND
import 'dart:ui';
import 'app_colors.g.dart';

enum AppThemeStyle {
  primary,
}

class AppThemeAssets {
  AppThemeAssets._();

  static AppColorScheme getScheme(AppThemeStyle style, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (style) {
      case AppThemeStyle.primary:
        return isDark ? const AppPalettePrimaryDark() : const AppPalettePrimaryLight();
    }
  }
}
