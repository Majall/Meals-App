import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/favourites_provider.dart';
import 'package:meals_app/providers/filters_provider.dart';
import 'package:meals_app/providers/theme_provider.dart';
import 'package:meals_app/screens/admin/admin_screen.dart';
import 'package:meals_app/screens/auth_screen.dart';
import 'package:meals_app/screens/categories_screen.dart';
import 'package:meals_app/screens/filters_screen.dart';
import 'package:meals_app/screens/meals_screen.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/glass_app_bar.dart';
import 'package:meals_app/widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'meals') {
      setState(() {
        _selectedPageIndex = 0;
      });
    }
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
    if (identifier == 'auth') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const AuthScreen(),
        ),
      );
    }
    if (identifier == 'admin') {
      setState(() {
        _selectedPageIndex = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);

    final pages = [
      CategoriesScreen(availableMaals: availableMeals),
      MealsScreen(
        meals: ref.watch(favouritesMealsProvider),
        title: 'Your favourites',
        subtitle: 'Meals you love, ready anytime',
      ),
      const AdminScreen(),
    ];

    final titles = [
      ('Categories', 'Discover something tasty'),
      ('Your favourites', 'Meals you love, ready anytime'),
      ('Admin studio', 'Analytics, operations, and updates'),
    ];

    final isWide = MediaQuery.of(context).size.width >= 900;
    final themeMode = ref.watch(themeModeProvider);
    final (title, subtitle) = titles[_selectedPageIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          drawer: isWide
              ? null
              : MainDrawer(
                  onSelectScreen: _setScreen,
                ),
          appBar: GlassAppBar(
            title: title,
            subtitle: subtitle,
            leading: isWide
                ? null
                : Builder(
                    builder: (context) => IconButton(
                      tooltip: 'Open menu',
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
            actions: [
              IconButton(
                tooltip: 'Toggle theme',
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),
          body: Row(
            children: [
              if (isWide)
                NavigationRail(
                  selectedIndex: _selectedPageIndex,
                  onDestinationSelected: _selectPage,
                  labelType: constraints.maxWidth >= 1100
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.selected,
                  extended: constraints.maxWidth >= 1100,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.set_meal_outlined),
                      selectedIcon: Icon(Icons.set_meal),
                      label: Text('Categories'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.star_border),
                      selectedIcon: Icon(Icons.star),
                      label: Text('Favourites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.analytics_outlined),
                      selectedIcon: Icon(Icons.analytics),
                      label: Text('Admin'),
                    ),
                  ],
                ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: KeyedSubtree(
                    key: ValueKey(_selectedPageIndex),
                    child: pages[_selectedPageIndex],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: _selectedPageIndex,
                  onDestinationSelected: _selectPage,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.set_meal_outlined),
                      selectedIcon: Icon(Icons.set_meal),
                      label: 'Categories',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.star_border),
                      selectedIcon: Icon(Icons.star),
                      label: 'Favourites',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.analytics_outlined),
                      selectedIcon: Icon(Icons.analytics),
                      label: 'Admin',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
