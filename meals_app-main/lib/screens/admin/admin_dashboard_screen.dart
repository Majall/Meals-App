import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/app_section_header.dart';
import 'package:meals_app/widgets/premium_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatCardData(
        title: 'Orders',
        value: '1,284',
        change: '+12.4%',
        icon: Icons.shopping_bag_outlined,
      ),
      _StatCardData(
        title: 'Revenue',
        value: '\$42.7k',
        change: '+8.1%',
        icon: Icons.payments_outlined,
      ),
      _StatCardData(
        title: 'Active users',
        value: '8,932',
        change: '+5.2%',
        icon: Icons.people_alt_outlined,
      ),
      _StatCardData(
        title: 'Satisfaction',
        value: '4.8/5',
        change: '+0.3',
        icon: Icons.star_border,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width > 1100
                  ? 4
                  : width > 900
                      ? 3
                      : width > 600
                          ? 2
                          : 1;
              final cardWidth =
                  (width - (columns - 1) * AppSpacing.lg) / columns;

              return Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                children: stats
                    .map(
                      (stat) => SizedBox(
                        width: cardWidth,
                        child: _StatCard(stat: stat),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          const AppSectionHeader(
            title: 'Performance trends',
            subtitle: 'Revenue and engagement across the last 7 days.',
            padding: EdgeInsets.zero,
          ),
          PremiumCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SizedBox(
              height: 260,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 12,
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.3),
                      strokeWidth: 1,
                    ),
                    drawVerticalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: 2,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          'D${value.toInt() + 1}',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      spots: const [
                        FlSpot(0, 4),
                        FlSpot(1, 6),
                        FlSpot(2, 5),
                        FlSpot(3, 7),
                        FlSpot(4, 9),
                        FlSpot(5, 8),
                        FlSpot(6, 11),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const AppSectionHeader(
            title: 'Highlights',
            subtitle: 'Quick visibility into high-impact signals.',
            padding: EdgeInsets.zero,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;
              final children = [
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top categories',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _HighlightRow(title: 'Fresh bowls', value: '38%'),
                      _HighlightRow(title: 'Protein-forward', value: '24%'),
                      _HighlightRow(title: 'Plant-based', value: '18%'),
                    ],
                  ),
                ),
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Automation health',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _HighlightRow(title: 'Fulfillment SLA', value: '96%'),
                      _HighlightRow(title: 'Delivery quality', value: '4.9/5'),
                      _HighlightRow(title: 'Support tickets', value: '12'),
                    ],
                  ),
                ),
              ];

              if (isNarrow) {
                return Column(
                  children: [
                    children.first,
                    const SizedBox(height: AppSpacing.lg),
                    children.last,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: children.first),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(child: children.last),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCardData {
  const _StatCardData({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
  });

  final String title;
  final String value;
  final String change;
  final IconData icon;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final _StatCardData stat;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PremiumCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colorScheme.primary.withOpacity(0.12),
            child: Icon(stat.icon, color: colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  stat.value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat.change,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightRow extends StatelessWidget {
  const _HighlightRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
