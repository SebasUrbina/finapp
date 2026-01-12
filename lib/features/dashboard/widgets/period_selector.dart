import 'package:finapp/features/dashboard/dashboard_state.dart';
import 'package:flutter/material.dart';

class PeriodSelector extends StatelessWidget {
  final PeriodFilter selectedPeriod;
  final DateTimeRange periodRange;
  final ValueChanged<PeriodFilter> onPeriodChanged;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.periodRange,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPeriodButton(
              context,
              'Week',
              PeriodFilter.week,
              selectedPeriod == PeriodFilter.week,
            ),
          ),
          Expanded(
            child: _buildPeriodButton(
              context,
              'Month',
              PeriodFilter.month,
              selectedPeriod == PeriodFilter.month,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(
    BuildContext context,
    String label,
    PeriodFilter period,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: () => onPeriodChanged(period),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? colors.onSurface : colors.onSurfaceVariant,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
