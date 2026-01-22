import 'package:flutter/material.dart';

/// A compact insight tip for the dashboard
class QuickInsight {
  final QuickInsightType type;
  final String message;
  final IconData? icon;

  const QuickInsight({required this.type, required this.message, this.icon});
}

enum QuickInsightType { success, warning, info }

class QuickInsightsCard extends StatelessWidget {
  final List<QuickInsight> insights;

  const QuickInsightsCard({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.2 : 0.05,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.primary, colors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 14,
                  color: colors.onPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Insights',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...insights.take(2).map((insight) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _InsightItem(insight: insight),
            );
          }),
        ],
      ),
    );
  }
}

class _InsightItem extends StatelessWidget {
  final QuickInsight insight;

  const _InsightItem({required this.insight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _getConfig(insight.type);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: config.color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            insight.icon ?? config.defaultIcon,
            color: config.color,
            size: 14,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            insight.message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  _InsightConfig _getConfig(QuickInsightType type) {
    switch (type) {
      case QuickInsightType.success:
        return _InsightConfig(
          color: const Color(0xFF4CAF50),
          defaultIcon: Icons.check_circle_rounded,
        );
      case QuickInsightType.warning:
        return _InsightConfig(
          color: const Color(0xFFFF6B6B),
          defaultIcon: Icons.warning_rounded,
        );
      case QuickInsightType.info:
        return _InsightConfig(
          color: const Color(0xFF42A5F5),
          defaultIcon: Icons.info_rounded,
        );
    }
  }
}

class _InsightConfig {
  final Color color;
  final IconData defaultIcon;

  _InsightConfig({required this.color, required this.defaultIcon});
}
