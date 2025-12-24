// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart' as img;

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart tool/ios_dark_icon_support.dart <path_to_xcassets>');
    exit(1);
  }

  final xcassetsPath = args[0];
  final flavors = ['dev', 'stg', 'prod'];

  for (final flavor in flavors) {
    _processFlavor(xcassetsPath, flavor);
  }
}

void _processFlavor(String xcassetsPath, String flavor) {
  final appIconSet = '$xcassetsPath/${flavor}AppIcon.appiconset';
  final contentsFile = File('$appIconSet/Contents.json');

  // The script runs from apps/mobile CWD, so the path is just 'assets/...'
  // We use icon_dark.png as the master 1024x1024 dark icon source (Opaque)
  // (splash_dark.png is now transparent and not suitable for app icons)
  final sourceDarkIconFile = File('assets/flavors/$flavor/icon_dark.png');

  if (!sourceDarkIconFile.existsSync()) {
    print('⚠️  No dark icon source found for $flavor at ${sourceDarkIconFile.path}');
    return;
  }

  print('🎨 Generating iOS 18 Full Dark Icon Set for $flavor...');

  // Decode the master image
  final masterImage = img.decodeImage(sourceDarkIconFile.readAsBytesSync());
  if (masterImage == null) {
    print('❌ Failed to decode master image for $flavor');
    return;
  }

  if (!contentsFile.existsSync()) {
    print('❌ Contents.json not found at ${contentsFile.path}');
    return;
  }

  final jsonContent = jsonDecode(contentsFile.readAsStringSync()) as Map<String, dynamic>;
  final images = (jsonContent['images'] as List).cast<Map<String, dynamic>>();

  // List of entries to add to Contents.json
  final newEntries = <Map<String, dynamic>>[];

  // Iterate through existing light images to find what we need to mirror
  // We make a copy to iterate over while potentially modifying the original list later
  for (final entry in List<Map<String, dynamic>>.from(images)) {
    // Skip if it's already a dark entry?
    if (entry.containsKey('appearances')) continue;

    final filename = entry['filename'] as String;
    final size = entry['size'] as String;
    final scale = entry['scale'] as String;
    final idiom = entry['idiom'] as String;

    // Construct new dark filename
    // e.g. Icon-App-20x20@2x.png -> Icon-App-20x20@2x-dark.png
    final extensionIndex = filename.lastIndexOf('.');
    final basename = filename.substring(0, extensionIndex);
    final extension = filename.substring(extensionIndex);
    final darkFilename = '$basename-dark$extension';

    // Determine pixel size needed
    // Easier way: parse size and scale
    var targetSize = 0;
    try {
      final sizeParts = size.split('x');
      final points = double.parse(sizeParts[0]);
      final scaleFactor = double.parse(scale.replaceAll('x', ''));
      targetSize = (points * scaleFactor).round();
    } catch (e) {
      print('   ⚠️ Could not parse size/scale for $filename. Skipping generation.');
      continue;
    }

    // Generate the resized image
    final resized = img.copyResize(masterImage, width: targetSize, height: targetSize, interpolation: img.Interpolation.average);
    final destPath = '$appIconSet/$darkFilename';
    File(destPath).writeAsBytesSync(img.encodePng(resized));
    // print('   ✨ Generated $darkFilename ($targetSize px)');

    // Create the JSON entry
    final darkEntry = <String, dynamic>{
      'size': size,
      'idiom': idiom,
      'filename': darkFilename,
      'scale': scale,
      'appearances': [
        {'appearance': 'luminosity', 'value': 'dark'},
      ],
    };
    newEntries.add(darkEntry);
  }

  // Remove old dark entries if any (to avoid duplicates)
  images.removeWhere((element) {
    if (!element.containsKey('appearances')) return false;
    final appearances = element['appearances'] as List;
    return appearances.any((a) => (a as Map)['value'] == 'dark');
  });

  // Add all new entries
  images.addAll(newEntries);

  const encoder = JsonEncoder.withIndent('  ');
  contentsFile.writeAsStringSync(encoder.convert(jsonContent));
  print('   ✅ Generated ${newEntries.length} dark icon variants for $flavor.');
}
