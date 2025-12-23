import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:map/map.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';

import '../../chat/data/chat_repository.dart';
import '../../requests/providers/request_provider.dart';
import 'map_controller.dart' as logic; // Alias to avoid conflict with flutter_map MapController

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(logic.mapControllerProvider);
    // Also listen to user location one-time or via the controller logic?
    // Using userLocationProvider directly here for initial position if state is empty
    final locationAsync = ref.watch(userLocationProvider);

    return Scaffold(
      body: Stack(
        children: [
          locationAsync.when(
            data: (location) {
              final center = location ?? const LatLng(40.7128, -74.0060);

              // If we have requests in state, use them. Else, we could trigger initial load.
              // For now, let's just use the provider directly for markers to keep it simple and reactive
              // BUT we want to support "Searching" state from controler.

              final requestsAsync = ref.watch(nearbyRequestsProvider((lat: center.latitude, lng: center.longitude, radius: 20.0)));

              final markers = requestsAsync.maybeWhen(
                data: (requests) => requests.where((req) => req.lat != null && req.lng != null).map((req) {
                  return Marker(
                    point: LatLng(req.lat!, req.lng!),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _showRequestDetails(context, ref, req),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: const Icon(Icons.handshake, color: Colors.white, size: 20),
                      ),
                    ),
                  );
                }).toList(),
                orElse: () => <Marker>[],
              );

              // Add User Marker
              if (location != null) {
                markers.add(
                  Marker(
                    point: location,
                    width: 24,
                    height: 24,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 2)],
                      ),
                      child: const Center(child: Icon(Icons.circle, size: 12, color: Colors.white)),
                    ),
                  ),
                );
              }

              return MapBuilder(mapController: _mapController, initialCenter: center, markers: markers);
            },
            loading: () => const Center(child: BreathingLoader()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),

          // Radar Pulse Overlay (when searching)
          if (state.isSearching) const Positioned.fill(child: MapRadar(color: Colors.blueAccent)),

          // Controls
          Positioned(
            right: 16,
            top: MediaQuery.of(context).viewInsets.top + 164,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MapZoomButtons(
                  onZoomIn: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, currentZoom + 1);
                  },
                  onZoomOut: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, currentZoom - 1);
                  },
                ),
                const SizedBox(height: 16),
                MapLocationButton(
                  onPressed: () {
                    final location = locationAsync.value;
                    if (location != null) {
                      _mapController.move(location, 15);
                      // Trigger "Radar" or refresh
                      ref.read(logic.mapControllerProvider.notifier).searchArea(location, 20);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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
            Text(req.title, style: context.h2),
            const SizedBox(height: 8),
            Text(req.description, style: context.bodyLarge),
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
