import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../../router.dart';

class GetUrgentHelpButton extends StatelessWidget {
  const GetUrgentHelpButton({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return TextButton.icon(
        onPressed: () => context.push(AppRoutes.urgentHelp),
        icon: Icon(Icons.health_and_safety_outlined, color: context.error),
        label: Text('Get urgent help', style: TextStyle(color: context.error)),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => context.push(AppRoutes.urgentHelp),
        icon: Icon(Icons.health_and_safety_outlined, color: context.error),
        label: Text('Get urgent help', style: TextStyle(color: context.error)),
      ),
    );
  }
}
