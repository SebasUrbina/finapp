import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SavingsInsightsCard extends StatelessWidget {
  final double savingsRate;
  final double totalIncome;
  final double totalSpending;
  final double netSavings;
  final double projectedMonthlySavings;

  const SavingsInsightsCard({
    super.key,
    required this.savingsRate,
    required this.totalIncome,
    required this.totalSpending,
    required this.netSavings,
    required this.projectedMonthlySavings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isPositive = netSavings >= 0;

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
                'Balance y Ahorro',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.savings_rounded,
                size: 20,
                color: colors.primary.withValues(alpha: 0.6),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Savings Rate Gauge
              SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  painter: _SavingsGaugePainter(
                    percentage: savingsRate.clamp(-100, 100),
                    isPositive: isPositive,
                    colors: colors,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${savingsRate.abs().toStringAsFixed(0)}%',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isPositive
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFFF6B6B),
                          ),
                        ),
                        Text(
                          isPositive ? 'Ahorro' : 'Déficit',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Income vs Expenses
              Expanded(
                child: Column(
                  children: [
                    _IncomeExpenseRow(
                      label: 'Ingresos',
                      amount: totalIncome,
                      color: const Color(0xFF4CAF50),
                      icon: Icons.arrow_downward_rounded,
                    ),
                    const SizedBox(height: 12),
                    _IncomeExpenseRow(
                      label: 'Gastos',
                      amount: totalSpending,
                      color: const Color(0xFFFF6B6B),
                      icon: Icons.arrow_upward_rounded,
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Balance',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${isPositive ? '+' : ''}${netSavings.toCurrency()}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isPositive
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFFF6B6B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (totalIncome > 0) ...[
            const Divider(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 18,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isPositive
                          ? 'A este ritmo ahorrarás ${projectedMonthlySavings.toCurrency()} al mes'
                          : 'Considera reducir gastos para equilibrar tu presupuesto',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
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
}

class _IncomeExpenseRow extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _IncomeExpenseRow({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
        Text(
          amount.toCurrency(),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SavingsGaugePainter extends CustomPainter {
  final double percentage;
  final bool isPositive;
  final ColorScheme colors;

  _SavingsGaugePainter({
    required this.percentage,
    required this.isPositive,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = 10.0;

    // Background arc
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = colors.surfaceContainerHighest;

    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: isPositive
            ? [const Color(0xFF4CAF50), const Color(0xFF81C784)]
            : [const Color(0xFFFF6B6B), const Color(0xFFFFB74D)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final progressSweep = (percentage.abs() / 100) * sweepAngle;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      progressSweep.clamp(0, sweepAngle),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
