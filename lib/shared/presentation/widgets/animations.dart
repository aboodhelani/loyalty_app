import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_colors.dart';

/// Fades and slides a child in on first build; [index] staggers list items.
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final int index;
  final Offset from;

  const FadeSlideIn({super.key, required this.child, this.index = 0, this.from = const Offset(0, 0.08)});

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
  late final _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    // Cap the stagger so long lists don't wait seconds for their tail.
    final delay = Duration(milliseconds: 55 * widget.index.clamp(0, 8));
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(
        position: Tween(begin: widget.from, end: Offset.zero).animate(_curve),
        child: widget.child,
      ),
    );
  }
}

/// Counts up to [value] when it first appears or changes.
class CountUp extends StatelessWidget {
  final num value;
  final TextStyle style;
  final String Function(num value)? format;

  const CountUp({super.key, required this.value, required this.style, this.format});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (_, v, __) => Text(format?.call(v) ?? v.round().toString(), style: style),
    );
  }
}

/// Shimmering placeholder block for loading states.
class Skeleton extends StatefulWidget {
  final double? width;
  final double height;
  final double radius;

  const Skeleton({super.key, this.width, required this.height, this.radius = 14});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value * 3 - 1;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius.sp),
            gradient: LinearGradient(
              begin: Alignment(t - 1, -0.3),
              end: Alignment(t + 1, 0.3),
              colors: [AppColors.surface, AppColors.surfaceElevated, AppColors.surface],
            ),
          ),
        );
      },
    );
  }
}
