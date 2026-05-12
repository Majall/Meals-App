import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meal_details_screen.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/app_empty_state.dart';
import 'package:meals_app/widgets/app_search_field.dart';
import 'package:meals_app/widgets/app_section_header.dart';
import 'package:meals_app/widgets/glass_app_bar.dart';
import 'package:meals_app/widgets/meal_item.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({
    super.key,
    this.title,
    this.subtitle,
    required this.meals,
  });

  final String? title;
  final String? subtitle;
  final List<Meal> meals;

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  Complexity? _selectedComplexity;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectedMeal(BuildContext context, Meal meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailsScreen(meal: meal),
      ),
    );
  }

  List<Meal> get _filteredMeals {
    return widget.meals.where((meal) {
      final matchesQuery =
          meal.title.toLowerCase().contains(_query.toLowerCase());
      final matchesComplexity = _selectedComplexity == null
          ? true
          : meal.complexity == _selectedComplexity;
      return matchesQuery && matchesComplexity;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final meals = _filteredMeals;
    final content = KeyedSubtree(
      key: ValueKey(meals.length),
      child: meals.isEmpty
          ? AppEmptyState(
              title: 'No meals found',
              subtitle: 'Try a different search or refine your filters.',
              icon: Icons.restaurant_menu,
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              itemCount: meals.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: MealItem(
                  meal: meals[index],
                  onSelectedMeal: _selectedMeal,
                ),
              ),
            ),
    );

    final body = Column(
      children: [
        AppSectionHeader(
          title: widget.title ?? 'Explore meals',
          subtitle:
              widget.subtitle ?? 'Handpicked recipes designed for your mood.',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AppSearchField(
            hintText: 'Search meals',
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: Complexity.values.map((complexity) {
              final isSelected = _selectedComplexity == complexity;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(
                    complexity.name[0].toUpperCase() +
                        complexity.name.substring(1),
                  ),
                  onSelected: (_) {
                    setState(() {
                      _selectedComplexity =
                          isSelected ? null : complexity;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: content,
          ),
        ),
      ],
    );

    if (widget.title == null) {
      return body;
    }

    return Scaffold(
      appBar: GlassAppBar(
        title: widget.title!,
        subtitle: widget.subtitle ?? 'Explore curated meal collections',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: body,
    );
  }
}
