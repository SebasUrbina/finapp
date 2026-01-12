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
        ),
      );

  // ========== State Management Methods ==========

  void setPeriod(PeriodFilter period) {
    state = state.copyWith(period: period);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  /// Refresh data from repository
  void refresh() {
    state = state.copyWith(
      transactions: _repository.getTransactions(),
      accounts: _repository.getAccounts(),
      categories: _repository.getCategories(),
    );
  }

  // ========== Computed Getters (Derived Values) ==========

  /// Get the date range for the current period
  DateTimeRange get periodRange {
    final date = state.selectedDate;

    if (state.period == PeriodFilter.week) {
      // Get the week (Monday to Sunday)
      final weekday = date.weekday;
      final monday = date.subtract(Duration(days: weekday - 1));
      final sunday = monday.add(const Duration(days: 6));
      return DateTimeRange(
        start: DateTime(monday.year, monday.month, monday.day),
        end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
      );
    } else {
      // Get the month
      final firstDay = DateTime(date.year, date.month, 1);
      final lastDay = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
      return DateTimeRange(start: firstDay, end: lastDay);
    }
  }

  /// Get transactions filtered by current period
  List<Transaction> get filteredTransactions {
    final range = periodRange;
    return state.transactions.where((t) {
      return t.date.isAfter(range.start.subtract(const Duration(seconds: 1))) &&
          t.date.isBefore(range.end.add(const Duration(seconds: 1)));
    }).toList()..sort((a, b) => b.date.compareTo(a.date)); // Most recent first
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
    return Money(totalIncome.cents - totalExpenses.cents);
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

    return Money(totalExpenses.cents ~/ days);
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
          icon: Icons.help_outline,
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
      ..sort((a, b) => b.value.cents.compareTo(a.value.cents));

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
}
