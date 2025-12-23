import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Palette (Deep Soft Purple)
  static const Color primaryLight = Color(0xFF917296);
  static const Color primaryDark = Color(0xFF4A3450);
  static const Color primaryDarkMetric = Color(0xFF4A3450);

  // Secondary Palette (Sage Green)
  static const Color secondaryLight = Color(0xFFBFE0D4);
  static const Color secondaryDark = Color(0xFF618A7A);

  // Backgrounds (Warm Off-White)
  static const Color backgroundLight = Color(0xFFFDFBF7);
  static const Color backgroundDark = Color(0xFF1A1A1E);

  // Surfaces
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF25252A);
  static const Color surfaceVariantLight = Color(0xFFF2F2F2);
  static const Color surfaceVariantDark = Color(0xFF3B3B3B);

  // Text & Icons
  static const Color textPrimaryLight = Color(0xFF2D2D2D);
  static const Color textPrimaryDark = Color(0xFFEDEDED);
  static const Color textSecondaryLight = Color(0xFF5A5A5A);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textDisabledLight = Color(0xFFB0B0B0);
  static const Color textDisabledDark = Color(0xFFB0B0B0);

  // Status
  static const Color errorLight = Color(0xFFD36135);
  static const Color errorDark = Color(0xFFD36135);
  static const Color successLight = Color(0xFF7FA87F);
  static const Color successDark = Color(0xFF7FA87F);
  static const Color warningLight = Color(0xFFE0A458);
  static const Color warningDark = Color(0xFFE0A458);

  // AppColors methods
  static Color primary(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? primaryDark : primaryLight;
  static Color secondary(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? secondaryDark : secondaryLight;
  static Color background(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? backgroundDark : backgroundLight;
  static Color surface(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? surfaceDark : surfaceLight;
  static Color surfaceVariant(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? surfaceVariantDark : surfaceVariantLight;
  static Color textPrimary(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? textPrimaryDark : textPrimaryLight;
  static Color textSecondary(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? textSecondaryDark : textSecondaryLight;
  static Color textDisabled(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? textDisabledDark : textDisabledLight;
  static Color error(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? errorDark : errorLight;
  static Color success(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? successDark : successLight;
  static Color warning(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? warningDark : warningLight;
}

extension AppColorsExtension on BuildContext {
  // Colors
  Color get primary => AppColors.primary(this);
  Color get secondary => AppColors.secondary(this);
  Color get background => AppColors.background(this);
  Color get surface => AppColors.surface(this);
  Color get surfaceVariant => AppColors.surfaceVariant(this);
  Color get textPrimary => AppColors.textPrimary(this);
  Color get textSecondary => AppColors.textSecondary(this);
  Color get textDisabled => AppColors.textDisabled(this);
  Color get error => AppColors.error(this);
  Color get success => AppColors.success(this);
  Color get warning => AppColors.warning(this);

  // Light Colors
  Color get primaryLight => AppColors.primaryLight;
  Color get secondaryLight => AppColors.secondaryLight;
  Color get backgroundLight => AppColors.backgroundLight;
  Color get surfaceLight => AppColors.surfaceLight;
  Color get surfaceVariantLight => AppColors.surfaceVariantLight;
  Color get textPrimaryLight => AppColors.textPrimaryLight;
  Color get textSecondaryLight => AppColors.textSecondaryLight;
  Color get textDisabledLight => AppColors.textDisabledLight;
  Color get errorLight => AppColors.errorLight;
  Color get successLight => AppColors.successLight;
  Color get warningLight => AppColors.warningLight;

  // Dark Colors
  Color get primaryDark => AppColors.primaryDark;
  Color get primaryDarkMetric => AppColors.primaryDarkMetric;
  Color get secondaryDark => AppColors.secondaryDark;
  Color get backgroundDark => AppColors.backgroundDark;
  Color get surfaceDark => AppColors.surfaceDark;
  Color get surfaceVariantDark => AppColors.surfaceVariantDark;
  Color get textPrimaryDark => AppColors.textPrimaryDark;
  Color get textSecondaryDark => AppColors.textSecondaryDark;
  Color get textDisabledDark => AppColors.textDisabledDark;
  Color get errorDark => AppColors.errorDark;
  Color get successDark => AppColors.successDark;
  Color get warningDark => AppColors.warningDark;
}
