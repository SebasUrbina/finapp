import 'package:finapp/features/insights/insights_state.dart';
import 'package:flutter/material.dart';

class InsightsTimeSelector extends StatelessWidget {
  final InsightsPeriod selectedPeriod;
  final String periodLabel;
  final ValueChanged<InsightsPeriod> onPeriodChanged;
  final VoidCallback onPreviousTap;
  final VoidCallback onNextTap;

  const InsightsTimeSelector({
    super.key,
    required this.selectedPeriod,
    required this.periodLabel,
    required this.onPeriodChanged,
    required this.onPreviousTap,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Period Selector Pills
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: InsightsPeriod.values.map((period) {
                final isSelected = period == selectedPeriod;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onPeriodChanged(period),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: colors.primary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _getPeriodLabel(period),
                          style: TextStyle(
                            color: isSelected
                                ? colors.onPrimary
                                : colors.onSurfaceVariant,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Navigation Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavigationButton(
                icon: Icons.chevron_left_rounded,
                onTap: onPreviousTap,
              ),
              Column(
                children: [
                  Text(
                    periodLabel,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getPeriodDescription(selectedPeriod),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              _NavigationButton(
                icon: Icons.chevron_right_rounded,
                onTap: onNextTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPeriodLabel(InsightsPeriod period) {
    switch (period) {
      case InsightsPeriod.week:
        return 'Semana';
      case InsightsPeriod.month:
        return 'Mes';
      case InsightsPeriod.quarter:
        return 'Trim.';
      case InsightsPeriod.year:
        return 'Año';
    }
  }

  String _getPeriodDescription(InsightsPeriod period) {
    switch (period) {
      case InsightsPeriod.week:
        return 'Vista semanal';
      case InsightsPeriod.month:
        return 'Vista mensual';
      case InsightsPeriod.quarter:
        return 'Vista trimestral';
      case InsightsPeriod.year:
        return 'Vista anual';
    }
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavigationButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: colors.onSurfaceVariant, size: 24),
        ),
      ),
    );
  }
}
