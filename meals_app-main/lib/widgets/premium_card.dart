import 'package:flutter/material.dart';
import 'package:meals_app/theme/app_theme.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.gradient,
    this.borderRadius = AppRadius.lg,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadows = Theme.of(context).extension<AppShadows>();
    final surfaceGradient = gradient ??
        LinearGradient(
          colors: [
            colorScheme.surface.withOpacity(0.95),
            colorScheme.surfaceVariant.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: surfaceGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows?.soft,
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.4),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
