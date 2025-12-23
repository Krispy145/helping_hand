import 'package:flutter/material.dart';

import 'app_colors.dart';

extension AppTextStylesExtension on BuildContext {
  TextStyle get h1 => TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: textPrimary, height: 1.3);

  TextStyle get h2 => TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: textPrimary, height: 1.3);

  TextStyle get h3 => TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary, height: 1.3);

  // Body
  TextStyle get bodyLarge => TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textPrimary, height: 1.5);

  TextStyle get bodyMedium => TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textPrimary, height: 1.5);

  TextStyle get bodySmall => TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: textSecondary, height: 1.5);

  // Buttons
  TextStyle get button => TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: surface, height: 1);
}
