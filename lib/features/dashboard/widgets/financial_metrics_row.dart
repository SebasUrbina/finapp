import 'package:finapp/features/dashboard/widgets/top_category_card.dart';
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
        // Top Category Card with Tag Filter
        Expanded(child: TopCategoryCard()),
        SizedBox(width: 12),
        // Savings Rate Card with Gauge
        Expanded(child: SavingsRateCard()),
        SizedBox(width: 12),
        // Daily Average Card with Trend Chart
        Expanded(child: DailyAverageCard()),
      ],
    );
  }
}
