import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/theme_provider.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/glass_container.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: GlassContainer(
                borderRadius: AppRadius.lg,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: colorScheme.primary.withOpacity(0.15),
                      child: Icon(
                        Icons.local_dining,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Foodie!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Let's cook something great",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('Meals'),
              onTap: () => onSelectScreen('meals'),
            ),
            ListTile(
              leading: const Icon(Icons.filter_alt_outlined),
              title: const Text('Filters'),
              onTap: () => onSelectScreen('filters'),
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Authentication'),
              onTap: () => onSelectScreen('auth'),
            ),
            ListTile(
              leading: const Icon(Icons.analytics_outlined),
              title: const Text('Admin Studio'),
              onTap: () => onSelectScreen('admin'),
            ),
            const Divider(),
            SwitchListTile(
              value: isDark,
              onChanged: (_) =>
                  ref.read(themeModeProvider.notifier).toggleTheme(),
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              title: const Text('Dark mode'),
              subtitle: Text(
                isDark ? 'Night-friendly appearance' : 'Bright clean interface',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Meals App • Premium Edition',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
