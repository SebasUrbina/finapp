import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class BudgetOverviewCard extends StatelessWidget {
  final double spent;
  final double limit;
  final double dailyBudget;
  final int daysRemaining;
  final double? projectedSpent;

  const BudgetOverviewCard({
    super.key,
    required this.spent,
    required this.limit,
    required this.dailyBudget,
    required this.daysRemaining,
    this.projectedSpent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final progress = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
    final percentUsed = (progress * 100).toInt();
    final isOverBudget = spent > limit;
    final isNearLimit = progress > 0.85 && !isOverBudget;

    // Gradient colors based on status
    final List<Color> gradientColors;
    if (isOverBudget) {
      gradientColors = [const Color(0xFFE53935), const Color(0xFFEF5350)];
    } else if (isNearLimit) {
      gradientColors = [const Color(0xFFFF8F00), const Color(0xFFFFA726)];
    } else {
      gradientColors = [colors.primary, colors.primary.withValues(alpha: 0.8)];
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Presupuesto del Mes',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              _buildStatusBadge(
                isOverBudget: isOverBudget,
                isNearLimit: isNearLimit,
                percentUsed: percentUsed,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                spent.toCurrency(),
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'de ${limit.toCurrency()}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progress bar
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$percentUsed% utilizado',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    isOverBudget
                        ? 'Excedido por ${(spent - limit).toCurrency()}'
                        : '${(limit - spent).toCurrency()} disponible',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Metrics row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MetricItem(
                    icon: Icons.calendar_today_rounded,
                    label: 'Diario disponible',
                    value: dailyBudget.toCurrency(),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _MetricItem(
                    icon: Icons.hourglass_bottom_rounded,
                    label: 'Días restantes',
                    value: '$daysRemaining días',
                  ),
                ),
              ],
            ),
          ),
          // Projection indicator
          if (projectedSpent != null && projectedSpent! > limit) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Proyección: ${projectedSpent!.toCurrency()} al final del mes',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge({
    required bool isOverBudget,
    required bool isNearLimit,
    required int percentUsed,
  }) {
    final IconData icon;
    final String text;
    final Color bgColor;

    if (isOverBudget) {
      icon = Icons.warning_rounded;
      text = 'Excedido';
      bgColor = Colors.white.withValues(alpha: 0.25);
    } else if (isNearLimit) {
      icon = Icons.error_outline_rounded;
      text = 'Cerca del límite';
      bgColor = Colors.white.withValues(alpha: 0.25);
    } else {
      icon = Icons.check_circle_outline_rounded;
      text = 'En control';
      bgColor = Colors.white.withValues(alpha: 0.2);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.7)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
