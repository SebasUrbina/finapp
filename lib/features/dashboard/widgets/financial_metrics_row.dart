import 'package:finapp/features/dashboard/widgets/metric_card.dart';
import 'package:finapp/features/dashboard/widgets/savings_rate_card.dart';
import 'package:finapp/features/dashboard/widgets/daily_average_card.dart';
import 'package:flutter/material.dart';

/// Financial insights with analytical metrics display
class FinancialMetricsRow extends StatelessWidget {
  const FinancialMetricsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: SavingsRateCard()),
        SizedBox(width: 12),
        Expanded(child: DailyAverageCard()),
      ],
    );
  }
}
