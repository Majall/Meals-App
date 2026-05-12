import 'package:flutter/material.dart';
import 'package:meals_app/screens/admin/admin_activity_screen.dart';
import 'package:meals_app/screens/admin/admin_dashboard_screen.dart';
import 'package:meals_app/screens/admin/admin_meals_screen.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/app_section_header.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          const AppSectionHeader(
            title: 'Admin studio',
            subtitle: 'Premium analytics, operations, and meal management.',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: TabBar(
              labelStyle: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Dashboard'),
                Tab(text: 'Meals'),
                Tab(text: 'Activity'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: TabBarView(
              children: const [
                AdminDashboardScreen(),
                AdminMealsScreen(),
                AdminActivityScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
