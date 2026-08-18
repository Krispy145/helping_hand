import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';
import 'package:utils/utils.dart';

import '../../auth/providers/auth_provider.dart';
import '../providers/pulse_provider.dart';

class PulseScreen extends ConsumerWidget {
  const PulseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).asData?.value;
    final summary = ref.watch(pulseSummaryProvider);
    final queue = ref.watch(pulseQueueProvider);

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: const Text('Humanity Pulse'),
        actions: [
          if (user?.name != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(user!.name!, style: context.bodySmall),
              ),
            ),
          TextButton(onPressed: () => ref.read(authProvider.notifier).logout(), child: const Text('Sign out')),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(pulseSummaryProvider);
          ref.invalidate(pulseQueueProvider);
          await Future.wait([ref.read(pulseSummaryProvider.future), ref.read(pulseQueueProvider.future)]);
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Community trends', style: context.h2),
            const SizedBox(height: 8),
            Text('Aggregates only. Counts below 5 are hidden.', style: context.bodyMedium.copyWith(color: context.textSecondary)),
            const SizedBox(height: 16),
            summary.when(
              data: (data) => _SummaryGrid(summary: data),
              loading: () => const Center(child: BreathingLoader()),
              error: (error, _) => Text(ExceptionMapper.map(error)),
            ),
            const SizedBox(height: 32),
            Text('Appeals queue', style: context.h2),
            const SizedBox(height: 8),
            Text('Review rejected requests. Overturning makes them visible to helpers.', style: context.bodyMedium.copyWith(color: context.textSecondary)),
            const SizedBox(height: 16),
            queue.when(
              data: (items) => items.isEmpty
                  ? Text('No open appeals.', style: context.bodyLarge.copyWith(color: context.textSecondary))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [for (final item in items) _AppealCard(item: item)],
                    ),
              loading: () => const Center(child: BreathingLoader()),
              error: (error, _) => Text(ExceptionMapper.map(error)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final PulseSummaryDto summary;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      ('Sessions completed', summary.sessionsCompleted),
      ('Requests helped', summary.requestsHelped),
      ('Requests rejected', summary.requestsRejected),
      ('Reports filed', summary.reportsFiled),
      ('Crisis routes', summary.crisisSupportRoutes),
      ('Harm reports', summary.harmReports),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final tile in tiles)
          SizedBox(
            width: 180,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${tile.$2}', style: context.h2.copyWith(color: context.primary)),
                    const SizedBox(height: 4),
                    Text(tile.$1, style: context.bodySmall.copyWith(color: context.textSecondary)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AppealCard extends ConsumerStatefulWidget {
  const _AppealCard({required this.item});

  final PulseQueueItemDto item;

  @override
  ConsumerState<_AppealCard> createState() => _AppealCardState();
}

class _AppealCardState extends ConsumerState<_AppealCard> {
  bool _busy = false;

  Future<void> _act(Future<void> Function(String id) action) async {
    setState(() => _busy = true);
    try {
      await action(widget.item.appealId);
      ref.invalidate(pulseQueueProvider);
      ref.invalidate(pulseSummaryProvider);
    } catch (error) {
      if (mounted) context.showErrorSnackBar(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.request.title, style: context.h3),
            const SizedBox(height: 8),
            Text(item.request.description, style: context.bodyMedium),
            const SizedBox(height: 12),
            if (item.triggeredRule != null) Text(item.triggeredRule!, style: context.bodySmall.copyWith(color: context.warning)),
            const SizedBox(height: 8),
            Text('Appeal: ${item.reason}', style: context.bodySmall.copyWith(color: context.textSecondary)),
            const SizedBox(height: 16),
            if (_busy)
              const BreathingLoader()
            else
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton(onPressed: () => _act(ref.read(pulseRepositoryProvider).uphold), child: const Text('Keep rejected')),
                  FilledButton(onPressed: () => _act(ref.read(pulseRepositoryProvider).overturn), child: const Text('Approve request')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
