import 'package:flutter/material.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/app_skeleton.dart';
import 'package:meals_app/widgets/premium_card.dart';

class CategoryGridItem extends StatefulWidget {
  const CategoryGridItem({
    super.key,
    required this.category,
    required this.onSelectedCategory,
  });

  final Category category;
  final void Function() onSelectedCategory;

  @override
  State<CategoryGridItem> createState() => _CategoryGridItemState();
}

class _CategoryGridItemState extends State<CategoryGridItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 200),
        child: Semantics(
          button: true,
          label: 'Category ${widget.category.title}',
          child: PremiumCard(
            padding: EdgeInsets.zero,
            onTap: widget.onSelectedCategory,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.category.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const SizedBox.expand(child: SkeletonBox());
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: widget.category.color.withOpacity(0.3),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white70,
                      size: 40,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.category.color.withOpacity(0.55),
                          colorScheme.surface.withOpacity(0.85),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.category.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
