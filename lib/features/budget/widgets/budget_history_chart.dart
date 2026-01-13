import 'package:flutter/material.dart';
import 'package:finapp/features/budget/budget_controller.dart';
import 'dart:math' as math;

/// Gráfico de barras simple para histórico de presupuesto
class BudgetHistoryChart extends StatelessWidget {
  final List<BudgetHistoryData> history;

  const BudgetHistoryChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    // Encontrar el valor máximo para escalar
    final maxValue = history.fold<int>(
      0,
      (max, data) =>
          math.max(max, math.max(data.budgeted.cents, data.spent.cents)),
    );

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: history.map((data) {
          final budgetedHeight = maxValue > 0
              ? (data.budgeted.cents / maxValue * 150).clamp(4.0, 150.0)
              : 4.0;
          final spentHeight = maxValue > 0
              ? (data.spent.cents / maxValue * 150).clamp(4.0, 150.0)
              : 4.0;
          final isOverBudget = data.spent.cents > data.budgeted.cents;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Barras
                  SizedBox(
                    height: 150,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Barra de presupuesto (fondo)
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 20,
                            height: budgetedHeight,
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        // Barra de gasto (frente)
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 20,
                            height: spentHeight,
                            decoration: BoxDecoration(
                              color: isOverBudget
                                  ? colors.error
                                  : colors.tertiary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Label
                  Text(
                    data.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: data.isCurrentPeriod
                          ? colors.primary
                          : colors.onSurfaceVariant,
                      fontWeight: data.isCurrentPeriod
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
