import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class MapLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapLocationButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(heroTag: 'my_location', backgroundColor: context.primary, foregroundColor: context.surface, onPressed: onPressed, child: const Icon(Icons.my_location));
  }
}
