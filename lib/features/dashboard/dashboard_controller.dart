import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/data/repositories/finance_repository.dart';
import 'package:finapp/features/dashboard/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardController extends StateNotifier<DashboardState> {
  final FinanceRepository _repository;

  DashboardController(this._repository)
    : super(
        DashboardState(
          period: PeriodFilter.month,
          selectedDate: DateTime.now(),
          transactions: _repository.getTransactions(),
          accounts: _repository.getAccounts(),
          categories: _repository.getCategories(),
          tags: _repository.getTags(),
        ),
      );

  // ========== State Management Methods ==========

  void setPeriod(PeriodFilter period) {
    state = state.copyWith(period: period);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setSelectedAccount(String? accountId) {
    state = state.copyWith(selectedAccountId: accountId);
  }

  /// Refresh data from repository
  void refresh() {
    state = state.copyWith(
      transactions: _repository.getTransactions(),
      accounts: _repository.getAccounts(),
      categories: _repository.getCategories(),
      tags: _repository.getTags(),
    );
  }

  Future<void> addCategory(Category category) async {
    await _repository.addCategory(category);
    refresh();
  }

  Future<void> updateCategory(Category category) async {
    await _repository.updateCategory(category);
    refresh();
  }

  Future<void> deleteCategory(String categoryId) async {
    await _repository.deleteCategory(categoryId);
    refresh();
  }

  // ========== Computed Getters (Derived Values) ==========

  /// Get the date range for the current period
  DateTimeRange get periodRange {
    final date = state.selectedDate;

    switch (state.period) {
      case PeriodFilter.year:
        // Get the year
        final firstDay = DateTime(date.year, 1, 1);
        final lastDay = DateTime(date.year, 12, 31, 23, 59, 59);
        return DateTimeRange(start: firstDay, end: lastDay);

      case PeriodFilter.week:
        // Get the week (Monday to Sunday)
        final weekday = date.weekday;
        final monday = date.subtract(Duration(days: weekday - 1));
        final sunday = monday.add(const Duration(days: 6));
        return DateTimeRange(
          start: DateTime(monday.year, monday.month, monday.day),
          end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
        );

      case PeriodFilter.month:
        // Get the month
        final firstDay = DateTime(date.year, date.month, 1);
        final lastDay = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: firstDay, end: lastDay);
    }
  }

  /// Get transactions filtered by current period and selected account
  List<Transaction> get filteredTransactions {
    final range = periodRange;
    var filtered = state.transactions.where((t) {
      return t.date.isAfter(range.start.subtract(const Duration(seconds: 1))) &&
          t.date.isBefore(range.end.add(const Duration(seconds: 1)));
    });

    // Filter by account if one is selected
    if (state.selectedAccountId != null) {
      filtered = filtered.where((t) => t.accountId == state.selectedAccountId);
    }

    return filtered.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first
  }

  /// Total income for the period
  Money get totalIncome {
    final incomeTransactions = filteredTransactions.where(
      (t) => t.type == TransactionType.income,
    );

    if (incomeTransactions.isEmpty) return const Money(0);

    return incomeTransactions.map((t) => t.amount).reduce((a, b) => a + b);
  }

  /// Total expenses for the period
  Money get totalExpenses {
    final expenseTransactions = filteredTransactions.where(
      (t) => t.type == TransactionType.expense,
    );

    if (expenseTransactions.isEmpty) return const Money(0);

    return expenseTransactions.map((t) => t.amount).reduce((a, b) => a + b);
  }

  /// Balance (income - expenses)
  Money get balance {
    return Money(totalIncome.value - totalExpenses.value);
  }

  /// Transaction count for the period
  int get transactionCount {
    return filteredTransactions.length;
  }

  /// Average daily spending
  Money get averageDailySpending {
    final range = periodRange;
    final days = range.end.difference(range.start).inDays + 1;

    if (days == 0) return const Money(0);

    return Money(totalExpenses.value / days);
  }

  /// Expenses grouped by category
  Map<Category, Money> get expensesByCategory {
    final expenseTransactions = filteredTransactions.where(
      (t) => t.type == TransactionType.expense && t.categoryId != null,
    );

    final Map<Category, Money> result = {};

    for (final transaction in expenseTransactions) {
      final category = state.categories.firstWhere(
        (c) => c.id == transaction.categoryId,
        orElse: () => const Category(
          id: 'unknown',
          name: 'Sin categoría',
          icon: CategoryIcon.home,
        ),
      );

      if (result.containsKey(category)) {
        result[category] = result[category]! + transaction.amount;
      } else {
        result[category] = transaction.amount;
      }
    }

    // Sort by amount (highest first)
    final sortedEntries = result.entries.toList()
      ..sort((a, b) => b.value.value.compareTo(a.value.value));

    return Map.fromEntries(sortedEntries);
  }

  /// Recent transactions (last 7)
  List<Transaction> get recentTransactions {
    return filteredTransactions.take(7).toList();
  }

  /// Get category by ID
  Category? getCategoryById(String? categoryId) {
    if (categoryId == null) return null;
    try {
      return state.categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Get account by ID
  Account? getAccountById(String accountId) {
    try {
      return state.accounts.firstWhere((a) => a.id == accountId);
    } catch (e) {
      return null;
    }
  }

  /// Savings rate as percentage (0-100)
  double get savingsRate {
    if (totalIncome.value == 0) return 0;
    final savings = totalIncome.value - totalExpenses.value;
    return (savings / totalIncome.value * 100).clamp(0, 100);
  }

  /// Get spending trend data for the last 6 periods
  List<SpendingTrendData> get spendingTrend {
    final List<SpendingTrendData> trend = [];
    final now = DateTime.now();

    for (int i = 5; i >= 0; i--) {
      DateTime periodStart;
      DateTime periodEnd;
      String label;

      if (state.period == PeriodFilter.week) {
        // Calculate week range
        final targetDate = now.subtract(Duration(days: i * 7));
        final weekday = targetDate.weekday;
        final monday = targetDate.subtract(Duration(days: weekday - 1));
        final sunday = monday.add(const Duration(days: 6));

        periodStart = DateTime(monday.year, monday.month, monday.day);
        periodEnd = DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

        // Label: "W1", "W2", etc. or date range for current week
        if (i == 0) {
          label = 'Esta';
        } else {
          label = 'S-$i';
        }
      } else {
        // Calculate month range
        final targetDate = DateTime(now.year, now.month - i, 1);
        periodStart = DateTime(targetDate.year, targetDate.month, 1);
        periodEnd = DateTime(
          targetDate.year,
          targetDate.month + 1,
          0,
          23,
          59,
          59,
        );

        // Label: "Ene", "Feb", etc.
        if (i == 0) {
          label = 'Este';
        } else {
          final monthNames = [
            'Ene',
            'Feb',
            'Mar',
            'Abr',
            'May',
            'Jun',
            'Jul',
            'Ago',
            'Sep',
            'Oct',
            'Nov',
            'Dic',
          ];
          label = monthNames[targetDate.month - 1];
        }
      }

      // Calculate expenses for this period
      final periodTransactions = state.transactions.where((t) {
        final isInPeriod =
            t.type == TransactionType.expense &&
            t.date.isAfter(periodStart.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(periodEnd.add(const Duration(seconds: 1)));

        if (!isInPeriod) return false;

        // Respect account filter if selected
        if (state.selectedAccountId != null) {
          return t.accountId == state.selectedAccountId;
        }

        return true;
      });

      final periodExpenses = periodTransactions.isEmpty
          ? const Money(0)
          : periodTransactions.map((t) => t.amount).reduce((a, b) => a + b);

      trend.add(
        SpendingTrendData(
          label: label,
          amount: periodExpenses,
          isCurrentPeriod: i == 0,
        ),
      );
    }

    return trend;
  }
}

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

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
      final repo = ref.watch(financeRepositoryProvider);
      return DashboardController(repo);
    });
