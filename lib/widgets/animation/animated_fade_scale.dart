import 'package:flutter/material.dart';

const Duration _kDuration = Duration(milliseconds: 250);

class AnimatedFadeScale extends StatefulWidget {
  const AnimatedFadeScale({
    super.key,
    required this.child,
    this.duration = _kDuration,
  });

  final Widget child;
  final Duration duration;

  @override
  State<AnimatedFadeScale> createState() => _AnimatedFadeScaleState();
}

class _AnimatedFadeScaleState extends State<AnimatedFadeScale> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: widget.duration,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: RepaintBoundary(
            child: Opacity(
              opacity: value,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
