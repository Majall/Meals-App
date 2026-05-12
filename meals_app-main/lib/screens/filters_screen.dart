import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/filters_provider.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/app_section_header.dart';
import 'package:meals_app/widgets/glass_app_bar.dart';
import 'package:meals_app/widgets/premium_card.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filtersProvider);
    final colorScheme = Theme.of(context).colorScheme;

    Widget buildFilterTile({
      required Filter filter,
      required String title,
      required String subtitle,
      required IconData icon,
    }) {
      return PremiumCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SwitchListTile.adaptive(
          value: activeFilters[filter]!,
          onChanged: (isChecked) {
            ref.read(filtersProvider.notifier).setFilter(filter, isChecked);
          },
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          secondary: CircleAvatar(
            backgroundColor: colorScheme.primary.withOpacity(0.15),
            child: Icon(icon, color: colorScheme.primary),
          ),
          activeColor: colorScheme.primary,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      );
    }

    return Scaffold(
      appBar: GlassAppBar(
        title: 'Filters',
        subtitle: 'Customize your premium meal feed',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          const AppSectionHeader(
            title: 'Personalize your feed',
            subtitle: 'Choose what fits your lifestyle and we will tailor the meals.',
            padding: EdgeInsets.zero,
          ),
          buildFilterTile(
            filter: Filter.glutenFree,
            title: 'Gluten-free',
            subtitle: 'Only include gluten-free meals.',
            icon: Icons.no_food_outlined,
          ),
          const SizedBox(height: AppSpacing.md),
          buildFilterTile(
            filter: Filter.lactoseFree,
            title: 'Lactose-free',
            subtitle: 'Only include lactose-free meals.',
            icon: Icons.icecream_outlined,
          ),
          const SizedBox(height: AppSpacing.md),
          buildFilterTile(
            filter: Filter.vegetarian,
            title: 'Vegetarian',
            subtitle: 'Only include vegetarian meals.',
            icon: Icons.eco_outlined,
          ),
          const SizedBox(height: AppSpacing.md),
          buildFilterTile(
            filter: Filter.vegan,
            title: 'Vegan',
            subtitle: 'Only include vegan meals.',
            icon: Icons.spa_outlined,
          ),
        ],
      ),
    );
  }
}
