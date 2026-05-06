import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/favourites_provider.dart';

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
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            actions: [
              IconButton(
                onPressed: () {
                  final wasAdded = ref
                      .read(favouritesMealsProvider.notifier)
                      .toggleMealFavouriteStatus(meal);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(wasAdded
                        ? 'Meal added to favourites'
                        : 'Meal removed from favourites'),
                    duration: const Duration(seconds: 2),
                  ));
                },
                icon: Icon(isFavourite ? Icons.star : Icons.star_border),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(meal.title),
              background: Hero(
                tag: meal.id,
                child: Image.network(
                  meal.imageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: meal.ingredients
                        .map(
                          (ingredient) => Chip(
                            avatar: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(ingredient.ingredientImage),
                            ),
                            label: Text(
                              '${ingredient.ingredientName} • ${ingredient.ingredientAmount}',
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Steps',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final step = meal.steps[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(step),
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
