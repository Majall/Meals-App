import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/screens/admin/admin_meal_form.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/app_search_field.dart';
import 'package:meals_app/widgets/app_section_header.dart';
import 'package:meals_app/widgets/app_toast.dart';
import 'package:meals_app/widgets/premium_card.dart';

class AdminMealsScreen extends ConsumerStatefulWidget {
  const AdminMealsScreen({super.key});

  @override
  ConsumerState<AdminMealsScreen> createState() => _AdminMealsScreenState();
}

class _AdminMealsScreenState extends ConsumerState<AdminMealsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Meal> _meals;
  int _rowsPerPage = 6;
  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _meals = [...ref.read(mealsProvider)];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCreateMealForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => AdminMealForm(
        categories: availabelCategories,
        onSubmit: (meal) {
          setState(() => _meals = [meal, ..._meals]);
          showAppToast(context, 'Meal created successfully');
        },
      ),
    );
  }

  List<Meal> get _filteredMeals {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _meals;
    }
    return _meals
        .where((meal) => meal.title.toLowerCase().contains(query))
        .toList();
  }

  void _sort<T>(
    Comparable<T> Function(Meal meal) getField,
    int columnIndex,
    bool ascending,
  ) {
    final meals = [..._meals];
    meals.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });
    setState(() {
      _meals = meals;
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dataSource = _MealDataSource(_filteredMeals, colorScheme);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Column(
        children: [
          const AppSectionHeader(
            title: 'Meal catalog',
            subtitle: 'Review, refine, and launch premium experiences.',
            padding: EdgeInsets.zero,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;
              if (isNarrow) {
                return Column(
                  children: [
                    AppSearchField(
                      hintText: 'Search meals or tags',
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _openCreateMealForm,
                        icon: const Icon(Icons.add),
                        label: const Text('New meal'),
                      ),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: AppSearchField(
                      hintText: 'Search meals or tags',
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: _openCreateMealForm,
                    icon: const Icon(Icons.add),
                    label: const Text('New meal'),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          PremiumCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: PaginatedDataTable(
                showCheckboxColumn: false,
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                rowsPerPage: _rowsPerPage,
                availableRowsPerPage: const [6, 12, 18],
                onRowsPerPageChanged: (value) {
                  if (value != null) {
                    setState(() => _rowsPerPage = value);
                  }
                },
                columnSpacing: AppSpacing.lg,
                headingRowColor: WidgetStateProperty.all(
                  colorScheme.surfaceVariant,
                ),
                columns: [
                  DataColumn(
                    label: const Text('Title'),
                    onSort: (index, ascending) =>
                        _sort((meal) => meal.title, index, ascending),
                  ),
                  DataColumn(
                    label: const Text('Duration'),
                    numeric: true,
                    onSort: (index, ascending) =>
                        _sort((meal) => meal.duration, index, ascending),
                  ),
                  DataColumn(
                    label: const Text('Complexity'),
                    onSort: (index, ascending) => _sort(
                      (meal) => meal.complexity.index,
                      index,
                      ascending,
                    ),
                  ),
                  const DataColumn(label: Text('Status')),
                  const DataColumn(label: Text('Actions')),
                ],
                source: dataSource,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealDataSource extends DataTableSource {
  _MealDataSource(this.meals, this.colorScheme);

  final List<Meal> meals;
  final ColorScheme colorScheme;

  @override
  DataRow? getRow(int index) {
    if (index >= meals.length) {
      return null;
    }
    final meal = meals[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(meal.title)),
        DataCell(Text('${meal.duration} min')),
        DataCell(Text(
          meal.complexity.name[0].toUpperCase() +
              meal.complexity.name.substring(1),
        )),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: const Text('Live'),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                tooltip: 'Edit meal',
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: () {},
              ),
              IconButton(
                tooltip: 'More actions',
                icon: const Icon(Icons.more_vert, size: 18),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => meals.length;

  @override
  int get selectedRowCount => 0;
}
