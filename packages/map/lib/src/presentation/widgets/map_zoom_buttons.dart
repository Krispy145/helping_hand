import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class MapZoomButtons extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const MapZoomButtons({super.key, required this.onZoomIn, required this.onZoomOut});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(heroTag: 'zoom_in', backgroundColor: context.surface, foregroundColor: context.textPrimary, onPressed: onZoomIn, child: const Icon(Icons.add)),
        const SizedBox(height: 8),
        FloatingActionButton.small(heroTag: 'zoom_out', backgroundColor: context.surface, foregroundColor: context.textPrimary, onPressed: onZoomOut, child: const Icon(Icons.remove)),
      ],
    );
  }
}
