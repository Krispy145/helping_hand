import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class MapRadar extends StatelessWidget {
  final double size;
  final Color? color;

  const MapRadar({super.key, this.size = 200, this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: BreathingLoader(size: size, color: color ?? Colors.blueAccent),
      ),
    );
  }
}
