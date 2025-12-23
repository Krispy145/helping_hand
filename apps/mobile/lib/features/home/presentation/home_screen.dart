import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../../router.dart';
import '../../map/presentation/map_controller.dart' as map_logic; // Alias to avoid conflict
import '../../map/presentation/map_screen.dart';
import '../../requests/providers/request_provider.dart';
import 'feed_screen.dart';
import 'home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(homeControllerProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text('Map'), icon: Icon(Icons.map)),
            ButtonSegment(value: 1, label: Text('Feed'), icon: Icon(Icons.list)),
          ],
          selected: {tabIndex},
          onSelectionChanged: (newSelection) {
            ref.read(homeControllerProvider.notifier).setTab(newSelection.first);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return context.primary;
              }
              return context.surface; // Or semi-transparent white
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return context.surface;
              }
              return context.textPrimary;
            }),
            visualDensity: VisualDensity.compact,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: context.surface,
              child: IconButton(
                icon: Icon(Icons.settings, color: context.textPrimary),
                onPressed: () => context.push(AppRoutes.settings),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: tabIndex, children: const [MapScreen(), FeedScreen()]),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'refresh', // Unique tag
            backgroundColor: context.surface,
            foregroundColor: context.primary,
            onPressed: () async {
              if (tabIndex == 0) {
                // Map Refresh
                // We need the center... MapController has it in state, or we use defaults.
                // Ideally MapController should know its center.
                final mapState = ref.read(map_logic.mapControllerProvider);
                await ref.read(map_logic.mapControllerProvider.notifier).searchArea(mapState.center, 20);
              } else {
                // Feed Refresh
                // Invalidate provider to show loading state
                // We also want a delay to seeing the loading spinner.
                // We can simply invalidate, and if the provider is fast, it flickers.
                // To force a delay, we can modify the provider or do a trick here.
                // Let's modify the provider slightly to have a min delay?
                // OR just invalidate. The user asked for simulated delay.
                // I will modify the provider to include a delay.
                ref.invalidate(nearbyRequestsProvider);
              }
            },
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(heroTag: 'add_request', onPressed: () => context.push(AppRoutes.createRequest), child: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
