import 'package:finapp/domain/models/finance_models.dart';
import 'package:flutter/material.dart';

// Opciones de filtrado en el dashboard
enum PeriodFilter { week, month, year }

/// Data class for spending trend
class SpendingTrendData {
  final String label;
  final Money amount;
  final bool isCurrentPeriod;

  SpendingTrendData({
    required this.label,
    required this.amount,
    required this.isCurrentPeriod,
  });
}

/// Insight type for dashboard
enum DashboardInsightType { success, warning, info }

/// Data class for dashboard insights
class DashboardInsight {
  final DashboardInsightType type;
  final String message;
  final IconData icon;

  const DashboardInsight({
    required this.type,
    required this.message,
    required this.icon,
  });
}

/// Data class for daily spending trend
class DailySpendingData {
  final DateTime date;
  final Money amount;
  final bool isToday;

  DailySpendingData({
    required this.date,
    required this.amount,
    required this.isToday,
  });
}
