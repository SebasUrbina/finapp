import 'package:flutter/material.dart';

class BudgetTrendChart extends StatelessWidget {
  final List<double> complianceHistory; // 6 months of compliance (0.0 to 1.2+)
  final List<String> monthLabels;

  const BudgetTrendChart({
    super.key,
    required this.complianceHistory,
    required this.monthLabels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (complianceHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxCompliance = complianceHistory.reduce((a, b) => a > b ? a : b);
    final averageCompliance =
        complianceHistory.reduce((a, b) => a + b) / complianceHistory.length;

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
              Text(
                'Historial de Cumplimiento',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _getComplianceColor(
                    averageCompliance,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Prom: ${(averageCompliance * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: _getComplianceColor(averageCompliance),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(complianceHistory.length, (index) {
                final compliance = complianceHistory[index];
                final label = index < monthLabels.length
                    ? monthLabels[index]
                    : '';
                final barHeight = maxCompliance > 0
                    ? (compliance / maxCompliance * 100).clamp(5.0, 100.0)
                    : 5.0;
                final isOverBudget = compliance > 1.0;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Percentage label
                        Text(
                          '${(compliance * 100).toStringAsFixed(0)}%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _getComplianceColor(compliance),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Bar
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                              width: double.infinity,
                              height: barHeight,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: isOverBudget
                                      ? [
                                          const Color(0xFFE53935),
                                          const Color(
                                            0xFFEF5350,
                                          ).withValues(alpha: 0.7),
                                        ]
                                      : [
                                          _getComplianceColor(compliance),
                                          _getComplianceColor(
                                            compliance,
                                          ).withValues(alpha: 0.6),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Month label
                        Text(
                          label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(
                color: const Color(0xFF4CAF50),
                label: 'Bajo control',
              ),
              const SizedBox(width: 16),
              _LegendItem(
                color: const Color(0xFFFF8F00),
                label: 'Cerca del límite',
              ),
              const SizedBox(width: 16),
              _LegendItem(color: const Color(0xFFE53935), label: 'Excedido'),
            ],
          ),
        ],
      ),
    );
  }

  Color _getComplianceColor(double compliance) {
    if (compliance > 1.0) {
      return const Color(0xFFE53935);
    } else if (compliance > 0.85) {
      return const Color(0xFFFF8F00);
    } else {
      return const Color(0xFF4CAF50);
    }
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
