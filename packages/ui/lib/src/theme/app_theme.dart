import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

extension AppThemeExtension on BuildContext {
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(primary: primary, secondary: secondary, error: error, onSecondary: Colors.white, onSurface: textPrimary),

      // Typography
      textTheme: TextTheme(displayLarge: h1, displayMedium: h2, displaySmall: h3, bodyLarge: bodyLarge, bodyMedium: bodyMedium, bodySmall: bodySmall),

      // Card Theme (Softly Rounded)
      // Card Theme (Softly Rounded)
      cardTheme: CardThemeData(
        color: surface,
        shadowColor: primary.withValues(alpha: 0.05),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: primary.withValues(alpha: 0.05)),
        ),
      ),

      // Input Decoration (Minimalist)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: textDisabled.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: textDisabled.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: error),
        ),
      ),

      // Button Theme (Rounded)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: button,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: button.copyWith(color: primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      // AppBar Theme (Clean)
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: h2,
        iconTheme: IconThemeData(color: textPrimary),
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryDark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.dark(primary: primaryDark, secondary: secondaryDark, error: error, surface: surfaceDark, onSurface: textPrimaryDark),

      // Typography
      textTheme: TextTheme(
        displayLarge: h1.copyWith(color: textPrimaryDark),
        displayMedium: h2.copyWith(color: textPrimaryDark),
        displaySmall: h3.copyWith(color: textPrimaryDark),
        bodyLarge: bodyLarge.copyWith(color: textPrimaryDark),
        bodyMedium: bodyMedium.copyWith(color: textPrimaryDark),
        bodySmall: bodySmall.copyWith(color: textSecondaryDark),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: surfaceDark,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: textSecondaryDark.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: textSecondaryDark.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryDarkMetric, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: error),
        ),
        labelStyle: TextStyle(color: textSecondaryDark),
        hintStyle: TextStyle(color: textSecondaryDark),
        prefixIconColor: textSecondaryDark,
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDarkMetric,
          foregroundColor: surfaceDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: button,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryDarkMetric,
          textStyle: button.copyWith(color: primaryDarkMetric),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: textPrimaryDark, height: 1.3),
        iconTheme: IconThemeData(color: textPrimaryDark),
      ),
    );
  }
}
