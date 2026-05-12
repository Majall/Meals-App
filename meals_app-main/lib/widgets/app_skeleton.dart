import 'package:flutter/material.dart';
import 'package:meals_app/theme/app_theme.dart';

class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shimmerPosition = _controller.value * 2 - 1;
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1 + shimmerPosition, -0.3),
              end: Alignment(1 + shimmerPosition, 0.3),
              colors: [
                colorScheme.surfaceVariant,
                colorScheme.surfaceVariant.withOpacity(0.4),
                colorScheme.surfaceVariant,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.height,
    this.width,
    this.radius = AppRadius.md,
  });

  final double? height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
