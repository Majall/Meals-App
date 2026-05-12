import 'package:flutter/material.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/premium_card.dart';

class AdminActivityScreen extends StatelessWidget {
  const AdminActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      _Activity(
        title: 'New seasonal menu published',
        subtitle: 'Updated 12 hero recipes with spring produce.',
        icon: Icons.auto_awesome,
        time: '5m ago',
      ),
      _Activity(
        title: 'Inventory sync completed',
        subtitle: 'Supply coverage improved to 98%.',
        icon: Icons.check_circle_outline,
        time: '25m ago',
      ),
      _Activity(
        title: 'Delivery experience review',
        subtitle: 'Customer feedback score reached 4.9.',
        icon: Icons.star_border,
        time: '2h ago',
      ),
      _Activity(
        title: 'Automation alert resolved',
        subtitle: 'Fulfillment latency back within target.',
        icon: Icons.notifications_active_outlined,
        time: 'Yesterday',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: PremiumCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  child: Icon(
                    activity.icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activity.subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  activity.time,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Activity {
  const _Activity({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.time,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String time;
}
