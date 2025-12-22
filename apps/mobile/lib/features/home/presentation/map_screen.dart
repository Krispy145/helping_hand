import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:map/map.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';

import '../../chat/data/chat_repository.dart';
import '../../requests/providers/request_provider.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get User Location
    final locationAsync = ref.watch(userLocationProvider);

    return locationAsync.when(
      data: (location) {
        final center = location ?? const LatLng(40.7128, -74.0060); // Default NYC

        // 2. Get Requests near location
        final requestsAsync = ref.watch(nearbyRequestsProvider((lat: center.latitude, lng: center.longitude, radius: 20.0)));

        return requestsAsync.when(
          data: (requests) {
            // 3. Convert to Markers
            final markers = requests.where((req) => req.lat != null && req.lng != null).map((req) {
              return Marker(
                point: LatLng(req.lat!, req.lng!),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => _showRequestDetails(context, ref, req),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: const Icon(Icons.handshake, color: Colors.white, size: 20),
                  ),
                ),
              );
            }).toList();

            markers.add(
              Marker(
                point: center,
                width: 20,
                height: 20,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            );

            // 4. Show Map
            return HelpingHandMap(initialCenter: center, markers: markers);
          },
          loading: () => const Center(child: BreathingLoader()),
          error: (e, s) => Center(child: Text('Error loading requests: $e')),
        );
      },
      loading: () => const Center(child: BreathingLoader()),
      error: (e, s) => Center(child: Text('Error getting location: $e')),
    );
  }

  void _showRequestDetails(BuildContext context, WidgetRef ref, RequestDto req) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(req.title, style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(req.description, style: AppTextStyles.bodyLarge),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  try {
                    final session = await ref.read(chatRepositoryProvider).createSession(req.id);
                    if (context.mounted) {
                      await context.push('/session/${session.id}');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                    }
                  }
                },
                child: const Text('Offer Help'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
