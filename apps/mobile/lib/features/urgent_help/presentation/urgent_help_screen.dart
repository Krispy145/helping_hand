import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import '../data/urgent_launcher.dart';
import '../data/urgent_routes.dart';

class UrgentHelpScreen extends StatelessWidget {
  const UrgentHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(title: const Text('Get urgent help')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Helping Hand is not an emergency service. If you are in danger, call emergency services first.',
            style: context.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'These are official South Africa routes. Keep contact in-app unless you are reaching a helpline.',
            style: context.bodySmall.copyWith(color: context.textSecondary),
          ),
          const SizedBox(height: 24),
          for (final route in zaUrgentRoutes) ...[
            _RouteCard(route: route),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.route});

  final UrgentRoute route;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        isThreeLine: true,
        leading: Icon(_iconFor(route.kind), color: context.error),
        title: Text(route.title, style: context.h3),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${route.subtitle}\n${route.actionLabel}',
            style: context.bodySmall,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => launchUrgentRoute(context, route),
      ),
    );
  }

  IconData _iconFor(UrgentRouteKind kind) {
    return switch (kind) {
      UrgentRouteKind.emergency => Icons.emergency_outlined,
      UrgentRouteKind.crisis => Icons.favorite_outline,
      UrgentRouteKind.police => Icons.local_police_outlined,
      UrgentRouteKind.fraud => Icons.report_outlined,
    };
  }
}
