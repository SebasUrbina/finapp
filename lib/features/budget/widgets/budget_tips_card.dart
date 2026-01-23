import 'package:finapp/features/budget/budget_state.dart';
import 'package:flutter/material.dart';

class BudgetTipsCard extends StatelessWidget {
  final List<BudgetTip> tips;

  const BudgetTipsCard({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (tips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.2 : 0.05,
            ),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Icons.lightbulb_rounded,
                      size: 16,
                      color: colors.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Alertas de Presupuesto',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${tips.length}',
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.asMap().entries.map((entry) {
            final index = entry.key;
            final tip = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < tips.length - 1 ? 12 : 0,
              ),
              child: _TipItem(tip: tip),
            );
          }),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final BudgetTip tip;

  const _TipItem({required this.tip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final tipConfig = _getTipConfig(tip.type);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tipConfig.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: tipConfig.color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: tipConfig.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(tip.iconType) ?? tipConfig.defaultIcon,
              color: tipConfig.color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: tipConfig.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _TipConfig _getTipConfig(BudgetTipType type) {
    switch (type) {
      case BudgetTipType.danger:
        return _TipConfig(
          color: const Color(0xFFE53935),
          defaultIcon: Icons.error_rounded,
        );
      case BudgetTipType.warning:
        return _TipConfig(
          color: const Color(0xFFFF8F00),
          defaultIcon: Icons.warning_rounded,
        );
      case BudgetTipType.success:
        return _TipConfig(
          color: const Color(0xFF4CAF50),
          defaultIcon: Icons.check_circle_rounded,
        );
      case BudgetTipType.info:
        return _TipConfig(
          color: const Color(0xFF42A5F5),
          defaultIcon: Icons.info_rounded,
        );
    }
  }

  IconData? _getIcon(BudgetIconType? iconType) {
    if (iconType == null) return null;
    switch (iconType) {
      case BudgetIconType.trendUp:
        return Icons.trending_up_rounded;
      case BudgetIconType.trendDown:
        return Icons.trending_down_rounded;
      case BudgetIconType.alert:
        return Icons.notification_important_rounded;
      case BudgetIconType.checkCircle:
        return Icons.check_circle_rounded;
      case BudgetIconType.savings:
        return Icons.savings_rounded;
      case BudgetIconType.warning:
        return Icons.warning_rounded;
      case BudgetIconType.celebration:
        return Icons.celebration_rounded;
    }
  }
}

class _TipConfig {
  final Color color;
  final IconData defaultIcon;

  _TipConfig({required this.color, required this.defaultIcon});
}
