import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/filters_provider.dart';
// import 'package:meals_app/screens/tabs.dart';
// import 'package:meals_app/widgets/main_drawer.dart';

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
      return Card(
        child: SwitchListTile(
          value: activeFilters[filter]!,
          onChanged: (isChecked) {
            ref.read(filtersProvider.notifier).setFilter(filter, isChecked);
          },
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          secondary: Icon(icon, color: colorScheme.primary),
          activeColor: colorScheme.primary,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Text(
            'Personalize your feed',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose what fits your lifestyle and we will tailor the meals.',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 16),
          buildFilterTile(
            filter: Filter.glutenFree,
            title: 'Gluten-free',
            subtitle: 'Only include gluten-free meals.',
            icon: Icons.no_food_outlined,
          ),
          buildFilterTile(
            filter: Filter.lactoseFree,
            title: 'Lactose-free',
            subtitle: 'Only include lactose-free meals.',
            icon: Icons.icecream_outlined,
          ),
          buildFilterTile(
            filter: Filter.vegetarian,
            title: 'Vegetarian',
            subtitle: 'Only include vegetarian meals.',
            icon: Icons.eco_outlined,
          ),
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
