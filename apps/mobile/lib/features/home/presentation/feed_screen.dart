import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../requests/providers/request_provider.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hardcoded location for MVP
    // In a real app we'd use Geolocator to get current position
    final nearbyAsync = ref.watch(nearbyRequestsProvider(
      (lat: 40.7128, lng: -74.0060, radius: 10.0),
    ));

    return nearbyAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(child: Text('No requests nearby. Be the first!'));
        }
        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(req.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(req.description),
                    const SizedBox(height: 4),
                    Text(
                      '${req.urgency.name} • ${req.status.name}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to details (later)
                },
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
