import 'package:flutter/material.dart';
import 'package:finapp/domain/models/dashboard_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/features/dashboard/dashboard_state.dart';
import 'package:finapp/core/utils/date_ranges.dart';

part 'dashboard_controller.g.dart';

// 1. Filtro de Fecha (Periodo)
// Esta es la manera de manejar el estado de los filtros usando riverpod generator
@riverpod
class DashboardPeriod extends _$DashboardPeriod {
  @override
  PeriodFilter build() => PeriodFilter.month;

  void setFilter(PeriodFilter filter) => state = filter;
}

// 2. Filtro de Cuenta (Opcional)
@riverpod
class DashboardSelectedAccount extends _$DashboardSelectedAccount {
  @override
  String? build() => null; // null = todas

  void setSelectedAccount(String? accountId) => state = accountId;
}

// 3. Date range providers
@riverpod
DateTimeRange dashboardDateRange(Ref ref) {
  final periodFilter = ref.watch(dashboardPeriodProvider);
  final now = DateTime.now();
  return buildRange(now, periodFilter);
}

@riverpod
DateTimeRange dashboardPreviousDateRange(Ref ref) {
  final periodFilter = ref.watch(dashboardPeriodProvider);
  final now = DateTime.now();
  return buildPreviousRange(now, periodFilter);
}

// 4. Filtro de transacciones (Actual)
@riverpod
List<Transaction> dashboardFilteredTransactions(Ref ref) {
  final accountId = ref.watch(dashboardSelectedAccountProvider);
  final transactions = ref.watch(transactionsProvider).value ?? [];
  final dateRange = ref.watch(dashboardDateRangeProvider);

  return transactions.where((tx) {
    // Filtro de fecha
    final inDate = isWithin(tx.date, dateRange);

    // Filtro de Cuenta
    final inAccount = accountId == null || tx.accountId == accountId;
    return inDate && inAccount;
  }).toList()..sort((a, b) => b.date.compareTo(a.date));
}

// 5. Metricas del Dashboard
@riverpod
DashboardMetrics dashboardMetrics(Ref ref) {
  // Datos actuales
  final currentTransactions = ref.watch(dashboardFilteredTransactionsProvider);

  // Datos previos (Necesitamos recalcular filtro para el periodo anterior)
  final accountId = ref.watch(dashboardSelectedAccountProvider);
  final allTransactions = ref.watch(transactionsProvider).value ?? [];
  final previousRange = ref.watch(dashboardPreviousDateRangeProvider);

  final previousTransactions = allTransactions.where((tx) {
    final inDate = isWithin(tx.date, previousRange);
    final inAccount = accountId == null || tx.accountId == accountId;
    return inDate && inAccount;
  });

  // Cálculos Actuales
  double totalIncome = 0;
  double totalExpense = 0;

  for (final tx in currentTransactions) {
    if (tx.type == TransactionType.income) {
      totalIncome += tx.amount.value;
    } else if (tx.type == TransactionType.expense) {
      totalExpense += tx.amount.value;
    }
  }

  final balance = totalIncome - totalExpense;

  // Cálculos Previos
  double previousIncome = 0;
  double previousExpense = 0;

  for (final tx in previousTransactions) {
    if (tx.type == TransactionType.income) {
      previousIncome += tx.amount.value;
    } else if (tx.type == TransactionType.expense) {
      previousExpense += tx.amount.value;
    }
  }

  // Otros cálculos
  final currentRange = ref.watch(dashboardDateRangeProvider);
  final days = currentRange.end
      .difference(currentRange.start)
      .inDays
      .clamp(1, 365);
  final averageDailySpending = totalExpense / days;

  return DashboardMetrics(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    balance: balance,
    previousIncome: previousIncome,
    previousExpense: previousExpense,
    averageDailySpending: averageDailySpending,
    transactionsCount: currentTransactions.length,
  );
}

// 6. Gastos por categoría
@riverpod
Map<Category, Money> dashboardExpensesByCategory(Ref ref) {
  final transactions = ref
      .watch(dashboardFilteredTransactionsProvider)
      .where((t) => t.type == TransactionType.expense);
  final categories = ref.watch(categoriesProvider).value ?? [];

  final breakdown = <String, double>{};
  for (final tx in transactions) {
    if (tx.categoryId != null) {
      breakdown[tx.categoryId!] =
          (breakdown[tx.categoryId!] ?? 0) + tx.amount.value;
    }
  }

  final result = <Category, Money>{};
  for (final entry in breakdown.entries) {
    try {
      final category = categories.firstWhere((c) => c.id == entry.key);
      result[category] = Money(entry.value);
    } catch (_) {}
  }

  // Sort by amount descending
  final sortedEntries = result.entries.toList()
    ..sort((a, b) => b.value.value.compareTo(a.value.value));

  return Map.fromEntries(sortedEntries);
}

// 7. Insights
@riverpod
List<DashboardInsight> dashboardInsights(Ref ref) {
  final metrics = ref.watch(dashboardMetricsProvider);
  final expensesByCategory = ref.watch(dashboardExpensesByCategoryProvider);

  final insights = <DashboardInsight>[];

  // Insight: Cambio de gastos
  if (metrics.previousExpense > 0) {
    final change =
        ((metrics.totalExpense - metrics.previousExpense) /
            metrics.previousExpense) *
        100;
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
  }

  // Insight: Mayor gasto
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

  // Insight: Tasa de ahorro
  if (metrics.totalIncome > 0 && insights.length < 2) {
    final savingsRate =
        ((metrics.totalIncome - metrics.totalExpense) / metrics.totalIncome) *
        100;

    if (savingsRate > 15) {
      insights.add(
        DashboardInsight(
          type: DashboardInsightType.success,
          message:
              'Ahorras el ${savingsRate.toStringAsFixed(0)}% de tus ingresos.',
          icon: Icons.savings_rounded,
        ),
      );
    }
  }

  return insights.take(2).toList();
}

// Extra Providers for UI Widgets compatibility

@riverpod
Money dashboardTotalIncome(Ref ref) {
  return Money(ref.watch(dashboardMetricsProvider).totalIncome);
}

@riverpod
Money dashboardTotalExpenses(Ref ref) {
  return Money(ref.watch(dashboardMetricsProvider).totalExpense);
}

@riverpod
Money dashboardBalance(Ref ref) {
  return Money(ref.watch(dashboardMetricsProvider).balance);
}

@riverpod
Money dashboardAverageDailySpending(Ref ref) {
  return Money(ref.watch(dashboardMetricsProvider).averageDailySpending);
}

@riverpod
int dashboardTransactionCount(Ref ref) {
  return ref.watch(dashboardMetricsProvider).transactionsCount;
}

@riverpod
double dashboardSavingsRate(Ref ref) {
  final metrics = ref.watch(dashboardMetricsProvider);
  if (metrics.totalIncome <= 0) return 0.0;
  return ((metrics.totalIncome - metrics.totalExpense) / metrics.totalIncome) *
      100;
}

@riverpod
double dashboardSpendingChangePercentage(Ref ref) {
  final metrics = ref.watch(dashboardMetricsProvider);
  if (metrics.previousExpense <= 0) return 0.0;
  return ((metrics.totalExpense - metrics.previousExpense) /
          metrics.previousExpense) *
      100;
}

@riverpod
MapEntry<Category, Money>? dashboardTopCategoryByTag(Ref ref, String? tagId) {
  final transactions = ref
      .watch(dashboardFilteredTransactionsProvider)
      .where((t) => t.type == TransactionType.expense);
  final categories = ref.watch(categoriesProvider).value ?? [];

  final filteredByTag = tagId == null
      ? transactions
      : transactions.where((t) {
          try {
            final category = categories.firstWhere((c) => c.id == t.categoryId);
            return category.tagIds.contains(tagId);
          } catch (_) {
            return false;
          }
        });

  if (filteredByTag.isEmpty) return null;

  final breakdown = <String, double>{};
  for (final tx in filteredByTag) {
    if (tx.categoryId != null) {
      breakdown[tx.categoryId!] =
          (breakdown[tx.categoryId!] ?? 0) + tx.amount.value;
    }
  }

  if (breakdown.isEmpty) return null;

  final topId = breakdown.entries
      .reduce((a, b) => a.value > b.value ? a : b)
      .key;

  try {
    final category = categories.firstWhere((c) => c.id == topId);
    return MapEntry(category, Money(breakdown[topId]!));
  } catch (_) {
    return null;
  }
}

@riverpod
List<DailySpendingData> dashboardDailySpendingTrend(Ref ref) {
  final dateRange = ref.watch(dashboardDateRangeProvider);
  final transactions = ref
      .watch(dashboardFilteredTransactionsProvider)
      .where((t) => t.type == TransactionType.expense);

  final dailyMap = <DateTime, double>{};

  // Normalize date range to remove time
  final start = DateTime(
    dateRange.start.year,
    dateRange.start.month,
    dateRange.start.day,
  );
  final end = DateTime(
    dateRange.end.year,
    dateRange.end.month,
    dateRange.end.day,
  );

  // Initialize map with 0s
  var current = start;
  while (!current.isAfter(end)) {
    dailyMap[current] = 0;
    current = current.add(const Duration(days: 1));
  }

  // Fill with transactions
  for (final tx in transactions) {
    final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
    if (dailyMap.containsKey(txDate)) {
      dailyMap[txDate] = (dailyMap[txDate] ?? 0) + tx.amount.value;
    }
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return dailyMap.entries.map((e) {
    return DailySpendingData(
      date: e.key,
      amount: Money(e.value),
      isToday: e.key.isAtSameMomentAs(today),
    );
  }).toList();
}

@riverpod
Future<DashboardState> dashboardState(Ref ref) async {
  return DashboardState(
    transactions: ref.watch(dashboardFilteredTransactionsProvider),
    accounts: await ref.watch(accountsProvider.future),
    categories: await ref.watch(categoriesProvider.future),
    tags: await ref.watch(allTagsProvider.future),
    selectedAccountId: ref.watch(dashboardSelectedAccountProvider),
    metrics: ref.watch(dashboardMetricsProvider),
    period: ref.watch(dashboardDateRangeProvider),
  );
}
