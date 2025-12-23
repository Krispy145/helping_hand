import 'dart:math' as math;

import 'package:flutter/material.dart';

class MapRadar extends StatefulWidget {
  final Color? color;
  final double size;

  const MapRadar({super.key, this.color, this.size = 200});

  @override
  State<MapRadar> createState() => _MapRadarState();
}

class _MapRadarState extends State<MapRadar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _RadarPainter(animation: _controller, color: widget.color ?? Colors.blueAccent),
          ),
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  _RadarPainter({required this.animation, required this.color}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    // Draw 3 rings
    _drawRing(canvas, center, maxRadius, animation.value);
    _drawRing(canvas, center, maxRadius, (animation.value + 0.33) % 1.0);
    _drawRing(canvas, center, maxRadius, (animation.value + 0.66) % 1.0);
  }

  void _drawRing(Canvas canvas, Offset center, double maxRadius, double t) {
    final radius = maxRadius * t;
    final opacity = 1.0 - t; // Fade out as it expands

    final paint = Paint()
      ..color = color
          .withValues(alpha: opacity * 0.5) // Max opacity 0.5
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    final borderPaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) => true;
}
