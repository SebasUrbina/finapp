import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'dashboard_aggregation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardQuickInsightsProvider =
    Provider.autoDispose<List<DashboardInsight>>((ref) {
      final change = ref.watch(dashboardSpendingChangePercentageProvider);
      final expensesByCategory = ref.watch(dashboardExpensesByCategoryProvider);
      final savingsRate = ref.watch(dashboardSavingsRateProvider);

      final insights = <DashboardInsight>[];

      if (change.abs() > 5) {
        insights.add(
          DashboardInsight(
            type: change > 0
                ? DashboardInsightType.warning
                : DashboardInsightType.success,
            message: change > 0
                ? 'Tus gastos subieron ${change.abs().toStringAsFixed(0)}%'
                : 'Reduciste tus gastos un ${change.abs().toStringAsFixed(0)}%',
            icon: change > 0
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
          ),
        );
      }

      if (expensesByCategory.isNotEmpty && insights.length < 2) {
        final top = expensesByCategory.entries.first;
        insights.add(
          DashboardInsight(
            type: DashboardInsightType.info,
            message: '${top.key.name} es tu mayor gasto.',
            icon: top.key.iconData,
          ),
        );
      }

      if (insights.length < 2 && savingsRate > 15) {
        insights.add(
          DashboardInsight(
            type: DashboardInsightType.success,
            message:
                'Ahorras el ${savingsRate.toStringAsFixed(0)}% de tus ingresos.',
            icon: Icons.savings_rounded,
          ),
        );
      }

      return insights.take(2).toList();
    });
