import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Palette (Deep Soft Purple)
  static const Color primary = Color(0xFF6B4E71);
  static const Color primaryLight = Color(0xFF917296);
  static const Color primaryDark = Color(0xFF4A3450);

  // Secondary Palette (Sage Green)
  static const Color secondary = Color(0xFF8FB9A8);
  static const Color secondaryLight = Color(0xFFBFE0D4);
  static const Color secondaryDark = Color(0xFF618A7A);

  // Backgrounds (Warm Off-White)
  static const Color background = Color(0xFFFDFBF7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF2F2F2);

  // Text & Icons
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF5A5A5A);
  static const Color textDisabled = Color(0xFFB0B0B0);

  // Status
  static const Color error = Color(0xFFD36135); // Muted red
  static const Color success = Color(0xFF7FA87F); // Muted green
  static const Color warning = Color(0xFFE0A458); // Muted orange
}
