import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// Handshake pin used for a single request or a cluster (with a count badge).
class RequestMapPin extends StatelessWidget {
  final bool busy;
  final int badgeCount;

  const RequestMapPin({
    super.key,
    this.busy = false,
    this.badgeCount = 0,
  });

  static const double size = 52;
  static const double _pinSize = 40;

  @override
  Widget build(BuildContext context) {
    final pin = SizedBox(
      width: _pinSize,
      height: _pinSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: busy ? const Color(0xFF9AA0A6) : context.primary,
          shape: BoxShape.circle,
          border: Border.all(color: context.surface, width: 2),
          boxShadow: [BoxShadow(color: context.shadow.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Icon(Icons.handshake, color: context.surface, size: 20),
      ),
    );

    if (badgeCount <= 1) return Center(child: pin);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(child: pin),
          Positioned(
            top: 0,
            right: 0,
            child: _NotificationBadge(count: badgeCount),
          ),
        ],
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  final int count;

  const _NotificationBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';
    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: context.error,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.surface, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: context.onError,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
      ),
    );
  }
}
