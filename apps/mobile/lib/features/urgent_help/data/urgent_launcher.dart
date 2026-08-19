import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utils/utils.dart';

import '../data/urgent_routes.dart';

Future<void> launchUrgentRoute(BuildContext context, UrgentRoute route) async {
  final uri = route.launchUri;
  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      context.showErrorSnackBar('Could not open ${route.actionLabel}.');
    }
  } catch (_) {
    if (context.mounted) {
      context.showErrorSnackBar('Could not open ${route.actionLabel}.');
    }
  }
}
