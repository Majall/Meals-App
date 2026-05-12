import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/app_skeleton.dart';
import 'package:meals_app/widgets/meal_item_trait.dart';
import 'package:meals_app/widgets/premium_card.dart';

class MealItem extends StatefulWidget {
  const MealItem({super.key, required this.meal, required this.onSelectedMeal});

  final Meal meal;
  final void Function(BuildContext context, Meal meal) onSelectedMeal;

  @override
  State<MealItem> createState() => _MealItemState();
}

class _MealItemState extends State<MealItem> {
  bool _isHovered = false;

  String get complexityText {
    return widget.meal.complexity.name[0].toUpperCase() +
        widget.meal.complexity.name.substring(1);
  }

  String get affordabilityText {
    return widget.meal.affordability.name[0].toUpperCase() +
        widget.meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.01 : 1,
        duration: const Duration(milliseconds: 200),
        child: Semantics(
          button: true,
          label: 'Meal ${widget.meal.title}',
          child: PremiumCard(
            padding: EdgeInsets.zero,
            onTap: () => widget.onSelectedMeal(context, widget.meal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: widget.meal.id,
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          widget.meal.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const SkeletonBox();
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color:
                                Theme.of(context).colorScheme.surfaceVariant,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: AppSpacing.md,
                        bottom: AppSpacing.md,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            '${widget.meal.duration} min',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.meal.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          MealItemTrait(
                            icon: Icons.schedule,
                            label: '${widget.meal.duration} min',
                          ),
                          MealItemTrait(
                            icon: Icons.work_outline,
                            label: complexityText,
                          ),
                          MealItemTrait(
                            icon: Icons.payments_outlined,
                            label: affordabilityText,
                          ),
                        ],
                      ),
                    ],
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
