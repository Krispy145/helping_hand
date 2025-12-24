import 'dart:convert';
import 'dart:io';

void main() async {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final rootDir = scriptDir.parent;
  final assetsDir = Directory('${rootDir.path}/assets/theme');
  final outputDir = Directory('${rootDir.path}/lib/src/theme/generated');

  if (!await outputDir.exists()) {
    await outputDir.create(recursive: true);
  }

  final themeFile = File('${assetsDir.path}/theme.json');
  if (await themeFile.exists()) {
    print('Processing theme.json...');
    final json = jsonDecode(await themeFile.readAsString()) as Map<String, dynamic>;

    await _generateThemeSystem(json, outputDir);

    print('Theme generation complete!');
  } else {
    print('theme.json not found in ${assetsDir.path}');
  }
}

Future<void> _generateThemeSystem(Map<String, dynamic> json, Directory outputDir) async {
  // Extract keys for styles (e.g. 'primary')
  final colorsMap = json['colors'] as Map<String, dynamic>? ?? {};
  final styles = colorsMap.keys.toList();

  // 1. Generate Colors (Palettes by style and mode)
  await _generateColors(colorsMap, outputDir);

  // 2. Generate Typography
  await _generateTypography(json, outputDir);

  // 3. Generate Enums and Lookup
  await _generateAssets(styles, outputDir);
}

Future<void> _generateColors(Map<String, dynamic> colorsMap, Directory outputDir) async {
  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer.writeln("import 'dart:ui';");
  buffer.writeln();

  // Define a common Interface/Class for a ColorScheme so we can use it interchangeably
  // We infer fields from the first available style/mode
  if (colorsMap.isEmpty) return;

  final firstStyle = colorsMap.values.first as Map<String, dynamic>;
  final firstMode = firstStyle.values.first as Map<String, dynamic>;

  buffer.writeln('class AppColorScheme {');
  buffer.writeln('  const AppColorScheme({');
  firstMode.forEach((key, _) {
    buffer.writeln('    required this.$key,');
  });
  buffer.writeln('  });');
  buffer.writeln();
  firstMode.forEach((key, _) {
    buffer.writeln('  final Color $key;');
  });
  buffer.writeln('}');
  buffer.writeln();

  // Generate instances for each Style + Mode
  colorsMap.forEach((styleKey, styleValue) {
    final modes = styleValue as Map<String, dynamic>;
    final styleName = _capitalize(styleKey); // Primary

    modes.forEach((modeKey, modeValue) {
      final modeName = _capitalize(modeKey); // Light / Dark
      final className = 'AppPalette$styleName$modeName'; // AppPalettePrimaryLight

      buffer.writeln('class $className extends AppColorScheme {');
      buffer.writeln('  const $className() : super(');

      (modeValue as Map<String, dynamic>).forEach((colorKey, colorVal) {
        if (colorVal is String) {
          final hex = _parseHex(colorVal);
          buffer.writeln('    $colorKey: const Color($hex),');
        }
      });
      buffer.writeln('  );'); // End super
      buffer.writeln('}'); // End class
      buffer.writeln();
    });
  });

  final outputFile = File('${outputDir.path}/app_colors.g.dart');
  await outputFile.writeAsString(buffer.toString());
  print('Generated ${outputFile.path}');
}

Future<void> _generateTypography(Map<String, dynamic> json, Directory outputDir) async {
  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer.writeln("import 'package:flutter/painting.dart';");
  buffer.writeln();
  buffer.writeln('class AppTypography {');
  buffer.writeln('  AppTypography._();');
  buffer.writeln();

  final textStyles = json['textStyles'] as Map<String, dynamic>?;
  if (textStyles != null && textStyles.containsKey('primary')) {
    final primaryStyles = textStyles['primary'] as Map<String, dynamic>;
    _traverseTypography(buffer, primaryStyles, '');
  }

  buffer.writeln('}');
  final outputFile = File('${outputDir.path}/app_text_styles.g.dart');
  await outputFile.writeAsString(buffer.toString());
  print('Generated ${outputFile.path}');
}

Future<void> _generateAssets(List<String> styles, Directory outputDir) async {
  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer.writeln("import 'dart:ui';");
  buffer.writeln("import 'app_colors.g.dart';");
  buffer.writeln();

  buffer.writeln('enum AppThemeStyle {');
  for (final s in styles) {
    buffer.writeln('  ${_toCamelCase(s)},');
  }
  buffer.writeln('}');
  buffer.writeln();

  buffer.writeln('class AppThemeAssets {');
  buffer.writeln('  AppThemeAssets._();');
  buffer.writeln();

  buffer.writeln('  static AppColorScheme getScheme(AppThemeStyle style, Brightness brightness) {');
  buffer.writeln('    final isDark = brightness == Brightness.dark;');
  buffer.writeln('    switch (style) {');

  for (final s in styles) {
    final enumName = _toCamelCase(s);
    final styleName = _capitalize(s);
    buffer.writeln('      case AppThemeStyle.$enumName:');
    buffer.writeln('        return isDark ? const AppPalette${styleName}Dark() : const AppPalette${styleName}Light();');
  }

  buffer.writeln('    }'); // End switch
  buffer.writeln('  }'); // End method
  buffer.writeln('}'); // End class

  final outputFile = File('${outputDir.path}/app_theme_assets.g.dart');
  await outputFile.writeAsString(buffer.toString());
  print('Generated ${outputFile.path}');
}

void _traverseTypography(StringBuffer buffer, Map<String, dynamic> node, String prefix) {
  if (node.containsKey('fontFamilyName_font') || node.containsKey('fontSize_double')) {
    final styleName = _toCamelCase(prefix);

    final family = node['fontFamilyName_font'] as String?;
    final weight = node['fontWeight_double'] as num?;
    final size = node['fontSize_double'] as num?;
    final letterSpacing = node['letterSpacing_double'] as num?;

    buffer.writeln('  static const TextStyle $styleName = TextStyle(');
    if (family != null) buffer.writeln("    fontFamily: '$family',");
    if (size != null) buffer.writeln('    fontSize: ${size.toDouble()},');
    if (weight != null) buffer.writeln('    fontWeight: FontWeight.w${weight.toInt()},');
    if (letterSpacing != null) buffer.writeln('    letterSpacing: ${letterSpacing.toDouble()},');
    buffer.writeln('  );');
    return;
  }

  node.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      final newPrefix = prefix.isEmpty ? key : '$prefix${_capitalize(key)}';
      _traverseTypography(buffer, value, newPrefix);
    }
  });
}

String _parseHex(String hex) {
  var cleanHex = hex.replaceAll('#', '');
  if (cleanHex.length == 6) {
    cleanHex = 'FF$cleanHex';
  } else if (cleanHex.length == 8) {
    final r = cleanHex.substring(0, 2);
    final g = cleanHex.substring(2, 4);
    final b = cleanHex.substring(4, 6);
    final a = cleanHex.substring(6, 8);
    cleanHex = '$a$r$g$b'; // RGGBBAA -> AARRGGBB
  }
  return '0x$cleanHex';
}

String _capitalize(String s) {
  if (s.isEmpty) return s;
  return '${s[0].toUpperCase()}${s.substring(1)}';
}

String _toCamelCase(String s) {
  return s;
}
