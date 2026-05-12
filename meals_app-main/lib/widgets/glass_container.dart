import 'dart:ui';

import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 24,
    this.blur = 18,
    this.tint,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double blur;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tint ?? colorScheme.surface.withOpacity(0.72),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.4),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
