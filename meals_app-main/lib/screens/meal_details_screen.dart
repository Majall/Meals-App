import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/favourites_provider.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/app_section_header.dart';
import 'package:meals_app/widgets/app_skeleton.dart';
import 'package:meals_app/widgets/app_toast.dart';
import 'package:meals_app/widgets/premium_card.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteMeals = ref.watch(favouritesMealsProvider);

    final isFavourite = favouriteMeals.contains(meal);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            actions: [
              IconButton(
                tooltip: 'Save to favourites',
                onPressed: () {
                  final wasAdded = ref
                      .read(favouritesMealsProvider.notifier)
                      .toggleMealFavouriteStatus(meal);
                  showAppToast(
                    context,
                    wasAdded
                        ? 'Meal added to favourites'
                        : 'Meal removed from favourites',
                    icon: wasAdded ? Icons.star : Icons.star_border,
                  );
                },
                icon: Icon(isFavourite ? Icons.star : Icons.star_border),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(meal.title),
              background: Hero(
                tag: meal.id,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      meal.imageUrl,
                      width: double.infinity,
                      height: 320,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const SkeletonBox();
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 48,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                AppSectionHeader(
                  title: 'Ingredients',
                  subtitle: 'Gather everything you need for this recipe.',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: meal.ingredients
                        .map(
                          (ingredient) => Chip(
                            avatar: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              child: ClipOval(
                                child: Image.network(
                                  ingredient.ingredientImage,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                            label: Text(
                              '${ingredient.ingredientName} · ${ingredient.ingredientAmount}',
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppSectionHeader(
                  title: 'Steps',
                  subtitle: 'Follow the crafted flow for perfect results.',
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final step = meal.steps[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: PremiumCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              step,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: meal.steps.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
