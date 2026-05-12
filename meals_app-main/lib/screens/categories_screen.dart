import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meals_screen.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/app_empty_state.dart';
import 'package:meals_app/widgets/app_footer.dart';
import 'package:meals_app/widgets/app_search_field.dart';
import 'package:meals_app/widgets/app_section_header.dart';
import 'package:meals_app/widgets/app_skeleton.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/widgets/premium_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMaals});

  final List<Meal> availableMaals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectedCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMaals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: category.title,
          subtitle: 'Curated picks for ${category.title.toLowerCase()}',
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = availabelCategories
        .where(
          (category) => category.title.toLowerCase().contains(
                _query.toLowerCase(),
              ),
        )
        .toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              offset: _isLoading ? const Offset(0, 0.05) : Offset.zero,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 450),
                opacity: _isLoading ? 0.85 : 1,
                child: PremiumCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover premium recipes',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Choose a curated category and explore elevated meal ideas.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppSearchField(
                        hintText: 'Search categories or keywords',
                        controller: _searchController,
                        onChanged: (value) => setState(() => _query = value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: AppSectionHeader(
            title: 'Trending categories',
            subtitle: 'Fresh picks crafted for every appetite.',
          ),
        ),
        if (_isLoading)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(
                  child: Column(
                    children: List.generate(
                      2,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: Row(
                          children: [
                            const Expanded(child: SkeletonBox(height: 140)),
                            const SizedBox(width: AppSpacing.lg),
                            const Expanded(child: SkeletonBox(height: 140)),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
          )
        else if (categories.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: AppEmptyState(
              title: 'No categories found',
              subtitle: 'Try a different search keyword to explore meals.',
              icon: Icons.search_off,
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final crossAxisCount = width > 1100
                    ? 4
                    : width > 720
                        ? 3
                        : 2;
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 4 / 3,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = categories[index];
                      return CategoryGridItem(
                        category: category,
                        onSelectedCategory: () {
                          _selectedCategory(context, category);
                        },
                      );
                    },
                    childCount: categories.length,
                  ),
                );
              },
            ),
          ),
        const SliverToBoxAdapter(
          child: AppFooter(),
        ),
      ],
    );
  }
}
