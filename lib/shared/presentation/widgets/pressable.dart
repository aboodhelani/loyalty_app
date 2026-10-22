import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Gives any tappable surface a soft press-down scale and a light haptic.
class Pressable extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final double scale;

  const Pressable({super.key, required this.child, this.enabled = true, this.scale = 0.97});

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool down) {
    if (!widget.enabled || _down == down) return;
    setState(() => _down = down);
    if (down) HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
