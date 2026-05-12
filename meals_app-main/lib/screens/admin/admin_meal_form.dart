import 'package:flutter/material.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/ingredient.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/app_section_header.dart';
import 'package:meals_app/widgets/app_text_field.dart';

class AdminMealForm extends StatefulWidget {
  const AdminMealForm({
    super.key,
    required this.categories,
    required this.onSubmit,
  });

  final List<Category> categories;
  final ValueChanged<Meal> onSubmit;

  @override
  State<AdminMealForm> createState() => _AdminMealFormState();
}

class _AdminMealFormState extends State<AdminMealForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _imageController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  Category? _selectedCategory;
  Complexity _complexity = Complexity.simple;
  Affordability _affordability = Affordability.affordable;
  bool _isGlutenFree = false;
  bool _isLactoseFree = false;
  bool _isVegan = false;
  bool _isVegetarian = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _imageController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final duration = int.tryParse(_durationController.text.trim()) ?? 20;
    final ingredients = _ingredientsController.text.trim().isEmpty
        ? [
            const Ingredients(
              ingredientName: 'Seasoning blend',
              ingredientImage:
                  'https://images.unsplash.com/photo-1506368249639-73a05d6f6488?auto=format&fit=crop&w=400&q=80',
              ingredientAmount: '1 tsp',
            ),
          ]
        : _ingredientsController.text
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .map(
              (line) => Ingredients(
                ingredientName: line.trim(),
                ingredientImage:
                    'https://images.unsplash.com/photo-1506368249639-73a05d6f6488?auto=format&fit=crop&w=400&q=80',
                ingredientAmount: '1x',
              ),
            )
            .toList();

    final steps = _stepsController.text.trim().isEmpty
        ? [
            'Prep ingredients and preheat as needed.',
            'Combine and cook using gentle heat.',
            'Plate and finish with fresh garnish.',
          ]
        : _stepsController.text
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();

    final meal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categories: [_selectedCategory!.id],
      title: _titleController.text.trim(),
      imageUrl: _imageController.text.trim().isEmpty
          ? 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1200&q=80'
          : _imageController.text.trim(),
      ingredients: ingredients,
      steps: steps,
      duration: duration,
      complexity: _complexity,
      affordability: _affordability,
      isGlutenFree: _isGlutenFree,
      isLactoseFree: _isLactoseFree,
      isVegan: _isVegan,
      isVegetarian: _isVegetarian,
    );

    widget.onSubmit(meal);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSectionHeader(
                title: 'Create meal entry',
                subtitle: 'Add a polished recipe to the catalog.',
                padding: EdgeInsets.zero,
              ),
              AppTextField(
                label: 'Meal title',
                controller: _titleController,
                hintText: 'Citrus salmon bowl',
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Please enter a title'
                        : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Duration (mins)',
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      hintText: '25',
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                      items: widget.categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.title),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Hero image URL',
                controller: _imageController,
                hintText: 'https://',
                textInputAction: TextInputAction.next,
                helperText: 'Use a 16:9 image for best results.',
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Complexity>(
                      value: _complexity,
                      decoration: const InputDecoration(labelText: 'Complexity'),
                      items: Complexity.values
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                value.name[0].toUpperCase() +
                                    value.name.substring(1),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _complexity = value ?? _complexity),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<Affordability>(
                      value: _affordability,
                      decoration:
                          const InputDecoration(labelText: 'Affordability'),
                      items: Affordability.values
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                value.name[0].toUpperCase() +
                                    value.name.substring(1),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(
                        () => _affordability = value ?? _affordability,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Key ingredients (one per line)',
                controller: _ingredientsController,
                hintText: 'Citrus salmon\nBaby spinach\nAvocado',
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Steps (one per line)',
                controller: _stepsController,
                hintText: 'Prep ingredients\nCook gently\nPlate and serve',
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  FilterChip(
                    selected: _isGlutenFree,
                    label: const Text('Gluten-free'),
                    onSelected: (value) =>
                        setState(() => _isGlutenFree = value),
                  ),
                  FilterChip(
                    selected: _isLactoseFree,
                    label: const Text('Lactose-free'),
                    onSelected: (value) =>
                        setState(() => _isLactoseFree = value),
                  ),
                  FilterChip(
                    selected: _isVegetarian,
                    label: const Text('Vegetarian'),
                    onSelected: (value) =>
                        setState(() => _isVegetarian = value),
                  ),
                  FilterChip(
                    selected: _isVegan,
                    label: const Text('Vegan'),
                    onSelected: (value) => setState(() => _isVegan = value),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Create meal'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
