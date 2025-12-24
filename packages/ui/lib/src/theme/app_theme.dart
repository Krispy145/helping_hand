import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'generated/app_colors.g.dart';
import 'generated/app_text_styles.g.dart';
import 'generated/app_theme_assets.g.dart';

export 'generated/app_colors.g.dart';
export 'generated/app_text_styles.g.dart';
export 'generated/app_theme_assets.g.dart';

/// State object needed for the Theme Provider
@immutable
class AppThemeState {
  final ThemeMode mode;
  final AppThemeStyle style;

  const AppThemeState({this.mode = ThemeMode.system, this.style = AppThemeStyle.primary});

  AppThemeState copyWith({ThemeMode? mode, AppThemeStyle? style}) {
    return AppThemeState(mode: mode ?? this.mode, style: style ?? this.style);
  }
}

/// Riverpod Provider for App Theme management
final appThemeProvider = NotifierProvider<AppThemeNotifier, AppThemeState>(AppThemeNotifier.new);

class AppThemeNotifier extends Notifier<AppThemeState> {
  @override
  AppThemeState build() {
    return const AppThemeState();
  }

  void setMode(ThemeMode mode) {
    state = state.copyWith(mode: mode);
  }

  void toggleTheme() {
    final isLight = state.mode == ThemeMode.light;
    state = state.copyWith(mode: isLight ? ThemeMode.dark : ThemeMode.light);
  }

  void setStyle(AppThemeStyle style) {
    state = state.copyWith(style: style);
  }
}

/// Extension to supply our custom [AppColorScheme] to Flutter's [ThemeData]
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final AppColorScheme scheme;

  const AppThemeExtension(this.scheme);

  @override
  ThemeExtension<AppThemeExtension> copyWith({AppColorScheme? scheme}) {
    return AppThemeExtension(scheme ?? this.scheme);
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(covariant ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    // We don't support lerping custom color schemes yet as it requires field-by-field lerping
    // generated in the assets. For now, snap to target.
    return t < 0.5 ? this : other;
  }
}

/// Helper to build the [ThemeData] from our [AppThemeAssets]
class AppTheme {
  static ThemeData build({required AppThemeStyle style, required Brightness brightness}) {
    final scheme = AppThemeAssets.getScheme(style, brightness);

    // Map our Generated Scheme to Flutter's Material ColorScheme
    // This allows standard widgets (AppBar, FAB, etc) to look correct automatically.
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: scheme.primary,
      onPrimary: scheme.onPrimary,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      secondary: scheme.secondary,
      onSecondary: scheme.onSecondary,
      secondaryContainer: scheme.secondaryContainer,
      onSecondaryContainer: scheme.onSecondaryContainer,
      tertiary: scheme.tertiary,
      onTertiary: scheme.onTertiary,
      tertiaryContainer: scheme.tertiaryContainer,
      onTertiaryContainer: scheme.onTertiaryContainer,
      error: scheme.error,
      onError: scheme.onError,
      errorContainer: scheme.errorContainer,
      onErrorContainer: scheme.onErrorContainer,
      surface: scheme.surface,
      onSurface: scheme.onSurface,
      // Map 'background' to surface if standard Material 3 doesn't use background explicitly,
      // but we have it in our palette.
      surfaceContainerHighest: scheme.surfaceVariant,
      onSurfaceVariant: scheme.onSurfaceVariant,
      outline: scheme.outline,
      outlineVariant: scheme.outlineVariant,
      shadow: scheme.shadow,
      scrim: scheme.scrim,
      inverseSurface: scheme.inverseSurface,
      onInverseSurface: scheme.onInverseSurface,
      inversePrimary: scheme.inversePrimary,
      surfaceTint: scheme.surfaceTint,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scheme.background,

      // Inject our full custom scheme as an extension for direct access
      extensions: [AppThemeExtension(scheme)],

      // Typography
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),

      // Component Themes using our Palette
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.background,
        iconTheme: IconThemeData(color: scheme.onSurface),
        titleTextStyle: AppTypography.titleLarge.copyWith(color: scheme.onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: scheme.primary, foregroundColor: scheme.onPrimary, textStyle: AppTypography.labelLarge),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
      ),
    );
  }
}

/// Context Extensions for easy access
extension AppThemeContext on BuildContext {
  /// Access the generated custom color scheme directly.
  /// Usage: `context.appColors.primary`
  AppColorScheme get appColors => Theme.of(this).extension<AppThemeExtension>()!.scheme;

  /// Access standard text theme (mapped from our typography)
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Access our semantic typography constants directly if preferred
  // Note: AppTypography is static, so 'AppTypography.h1' works anywhere.
  // But if we wanted dynamic scaling, we'd go through Theme.of(context).textTheme.

  // --- Convenience Color Getters (Backward Compatibility) ---
  Color get primary => appColors.primary;
  Color get onPrimary => appColors.onPrimary;
  Color get primaryContainer => appColors.primaryContainer;
  Color get onPrimaryContainer => appColors.onPrimaryContainer;

  Color get secondary => appColors.secondary;
  Color get onSecondary => appColors.onSecondary;
  Color get secondaryContainer => appColors.secondaryContainer;
  Color get onSecondaryContainer => appColors.onSecondaryContainer;

  Color get tertiary => appColors.tertiary;
  Color get onTertiary => appColors.onTertiary;
  Color get tertiaryContainer => appColors.tertiaryContainer;
  Color get onTertiaryContainer => appColors.onTertiaryContainer;

  Color get error => appColors.error;
  Color get onError => appColors.onError;
  Color get errorContainer => appColors.errorContainer;
  Color get onErrorContainer => appColors.onErrorContainer;

  Color get background => appColors.background;
  Color get onBackground => appColors.onBackground;

  Color get surface => appColors.surface;
  Color get onSurface => appColors.onSurface;
  Color get surfaceVariant => appColors.surfaceVariant;
  Color get onSurfaceVariant => appColors.onSurfaceVariant;

  Color get outline => appColors.outline;
  Color get outlineVariant => appColors.outlineVariant;

  Color get shadow => appColors.shadow;
  Color get scrim => appColors.scrim;
  Color get surfaceTint => appColors.surfaceTint;
  Color get inverseSurface => appColors.inverseSurface;
  Color get onInverseSurface => appColors.onInverseSurface;
  Color get inversePrimary => appColors.inversePrimary;

  // Semantic Aliases
  Color get textPrimary => appColors.onSurface;
  Color get textSecondary => appColors.onSurfaceVariant;
  Color get textDisabled => appColors.disabled;

  Color get warning => appColors.warning;
  Color get onWarning => appColors.onWarning;
  Color get warningContainer => appColors.warningContainer;
  Color get onWarningContainer => appColors.onWarningContainer;

  Color get success => appColors.confirmation; // Map success -> confirmation
  Color get confirmation => appColors.confirmation;
  Color get onConfirmation => appColors.onConfirmation;
  Color get confirmationContainer => appColors.confirmationContainer;
  Color get onConfirmationContainer => appColors.onConfirmationContainer;

  Color get information => appColors.information;
  Color get onInformation => appColors.onInformation;
  Color get informationContainer => appColors.informationContainer;
  Color get onInformationContainer => appColors.onInformationContainer;

  // --- Convenience Typography Getters (Backward Compatibility) ---
  // Applying default colors to ensure they look good on the current background

  TextStyle get h1 => AppTypography.headlineLarge.copyWith(color: textPrimary, height: 1.3);
  TextStyle get h2 => AppTypography.headlineMedium.copyWith(color: textPrimary, height: 1.3);
  TextStyle get h3 => AppTypography.headlineSmall.copyWith(color: textPrimary, height: 1.3);

  TextStyle get bodyLarge => AppTypography.bodyLarge.copyWith(color: textPrimary, height: 1.5);
  TextStyle get bodyMedium => AppTypography.bodyMedium.copyWith(color: textPrimary, height: 1.5);
  TextStyle get bodySmall => AppTypography.bodySmall.copyWith(color: textSecondary, height: 1.5);

  TextStyle get button => AppTypography.labelLarge.copyWith(color: surface, height: 1, fontWeight: FontWeight.w600);

  // Access generated typography directly if needed
  TextStyle get displayLarge => AppTypography.displayLarge;
  TextStyle get displayMedium => AppTypography.displayMedium;
  TextStyle get displaySmall => AppTypography.displaySmall;
  // ... others available via static AppTypography if needed, or textTheme
}
