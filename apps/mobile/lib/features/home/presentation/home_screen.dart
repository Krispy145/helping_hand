import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../../router.dart';
import '../../map/presentation/map_screen.dart';
import '../../requests/providers/request_provider.dart';
import '../../verification/presentation/verification_gate.dart';
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
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            _HomeRoundIcon(icon: Icons.chat_bubble, onPressed: () => context.push(AppRoutes.chats)),
            Expanded(
              child: Center(
                child: SegmentedButton<int>(
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
                      return context.surface;
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
              ),
            ),
            _HomeRoundIcon(icon: Icons.settings, onPressed: () => context.push(AppRoutes.settings)),
          ],
        ),
      ),
      body: IndexedStack(index: tabIndex, children: const [MapScreen(), FeedScreen()]),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'refresh',
            backgroundColor: context.surface,
            foregroundColor: context.primary,
            onPressed: () => ref.read(nearbyRequestsProvider.notifier).refresh(),
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'add_request',
            onPressed: () async {
              if (await ensureVerifiedAdult(context, ref) && context.mounted) {
                await context.push(AppRoutes.createRequest);
              }
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _HomeRoundIcon extends StatelessWidget {
  const _HomeRoundIcon({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: context.surface,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 40, height: 40),
        iconSize: 22,
        icon: Icon(icon, color: context.textPrimary),
        onPressed: onPressed,
      ),
    );
  }
}
