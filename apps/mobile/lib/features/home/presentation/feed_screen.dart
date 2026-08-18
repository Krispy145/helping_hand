import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';

import '../../../router.dart';
import '../../chat/data/chat_repository.dart';
import '../../reports/presentation/report_entry.dart';
import '../../requests/presentation/request_assist.dart';
import '../../requests/providers/request_provider.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyAsync = ref.watch(nearbyRequestsProvider);
    final mySessions = ref.watch(mySessionsProvider).asData?.value;
    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    return nearbyAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(child: Text('No requests in this area.'));
        }
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(0, topInset, 0, 120),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            final mine = sessionForRequest(mySessions, req.id);
            final busy = req.isBusy;

            return Opacity(
              opacity: busy ? 0.55 : 1,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: busy ? context.surfaceVariant : null,
                child: ListTile(
                  title: Text(req.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(req.description),
                      const SizedBox(height: 4),
                      Text(
                        busy ? 'Busy · someone is helping' : '${req.urgency.name} • ${req.status.name}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Report',
                        onPressed: () => context.push(
                          AppRoutes.report,
                          extra: ReportEntry(
                            requestId: req.id,
                            targetUserId: req.user?.id,
                            suggestedType: ReportTypeDto.HELPEE_MISUSE,
                          ),
                        ),
                        icon: Icon(Icons.flag_outlined, color: context.error),
                      ),
                      ElevatedButton(
                        onPressed: () => openOrStartAssist(context: context, ref: ref, request: req),
                        child: Text(mine != null ? 'Open chat' : busy ? 'Busy' : 'Assist'),
                      ),
                    ],
                  ),
                  onTap: () => openOrStartAssist(context: context, ref: ref, request: req),
                ),
              ),
            );
          },
        );
      },
      error: (err, stack) => Center(child: Text('Error: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
