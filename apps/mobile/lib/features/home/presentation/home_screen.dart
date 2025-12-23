import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../map/presentation/map_screen.dart';
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
        backgroundColor: Colors.transparent, // Floating effect
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
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: context.surface,
              child: IconButton(
                icon: Icon(Icons.settings, color: context.textPrimary),
                onPressed: () => context.push('/settings'),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: tabIndex, children: const [MapScreen(), FeedScreen()]),
      floatingActionButton: FloatingActionButton(onPressed: () => context.push('/create-request'), child: const Icon(Icons.add)),
    );
  }
}
