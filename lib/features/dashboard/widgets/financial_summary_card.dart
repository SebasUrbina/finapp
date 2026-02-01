import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'package:finapp/features/dashboard/dashboard_state.dart';
import 'package:finapp/features/dashboard/providers/dashboard_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinancialSummaryCard extends ConsumerWidget {
  final PeriodFilter selectedPeriod;
  final ValueChanged<PeriodFilter> onPeriodChanged;

  const FinancialSummaryCard({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final income = ref.watch(dashboardTotalIncomeProvider);
    final expenses = ref.watch(dashboardTotalExpensesProvider);
    final savings = ref.watch(dashboardBalanceProvider);
    final savingsRate = ref.watch(dashboardSavingsRateProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Period Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resumen Financiero',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildPeriodToggle(context),
            ],
          ),
          const SizedBox(height: 20),

          // Main content: Financial data + Chart
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Financial data
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFinancialRow(
                      context,
                      'Ingresos',
                      income.toCurrency(),
                      colors.primary,
                      Icons.arrow_downward_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildFinancialRow(
                      context,
                      'Gastos',
                      expenses.toCurrency(),
                      colors.error,
                      Icons.arrow_upward_rounded,
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      color: colors.outlineVariant.withValues(alpha: 0.5),
                      height: 1,
                    ),
                    const SizedBox(height: 12),
                    _buildFinancialRow(
                      context,
                      'Ahorro',
                      savings.toCurrency(),
                      savings.value >= 0 ? colors.primary : colors.error,
                      Icons.savings_outlined,
                    ),
                    const SizedBox(height: 8),
                    // Savings percentage
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${savingsRate.toStringAsFixed(0)}% ahorrado',
                        style: TextStyle(
                          color: colors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Right side: Spending trend chart
              Expanded(flex: 2, child: _buildSpendingTrendChart(context, ref)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(
    BuildContext context,
    String label,
    String amount,
    Color color,
    IconData icon,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                amount,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingTrendChart(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final trendData = ref.watch(dashboardSpendingTrendProvider);

    if (trendData.isEmpty) {
      return Center(
        child: Text(
          'Sin datos',
          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
        ),
      );
    }

    // Find max value for scaling
    final maxAmount = trendData
        .map((d) => d.amount.value)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tendencia',
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxAmount > 0 ? maxAmount * 1.2 : 100,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < trendData.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            trendData[value.toInt()].label,
                            style: TextStyle(
                              color: colors.onSurfaceVariant.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: trendData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final isCurrentPeriod = data.isCurrentPeriod;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data.amount.value,
                      color: isCurrentPeriod
                          ? colors.primary
                          : colors.primary.withValues(alpha: 0.4),
                      width: 12,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodToggle(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            context,
            'Semana',
            PeriodFilter.week,
            selectedPeriod == PeriodFilter.week,
          ),
          const SizedBox(width: 4),
          _buildToggleButton(
            context,
            'Mes',
            PeriodFilter.month,
            selectedPeriod == PeriodFilter.month,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    BuildContext context,
    String label,
    PeriodFilter period,
    bool isSelected,
  ) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => onPeriodChanged(period),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
