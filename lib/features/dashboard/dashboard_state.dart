import 'package:flutter/material.dart';
import 'package:finapp/domain/models/finance_models.dart';

// import 'package:freezed_annotation/freezed_annotation.dart';

class DashboardMetrics {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final double previousIncome;
  final double previousExpense;
  final double averageDailySpending;
  final int transactionsCount;

  DashboardMetrics({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.previousIncome,
    required this.previousExpense,
    required this.averageDailySpending,
    required this.transactionsCount,
  });
}

class DashboardState {
  final List<Transaction> transactions;
  final List<Account> accounts;
  final List<Category> categories;
  final List<Tag> tags;
  final String? selectedAccountId; // null = "General" (todas las cuentas)
  final DashboardMetrics metrics;
  final DateTimeRange period;

  const DashboardState({
    required this.transactions,
    required this.accounts,
    required this.categories,
    required this.tags,
    this.selectedAccountId,
    required this.metrics,
    required this.period,
  });

  DashboardState copyWith({
    String? selectedAccountId,
    List<Transaction>? transactions,
    List<Account>? accounts,
    List<Category>? categories,
    List<Tag>? tags,
    DashboardMetrics? metrics,
    DateTimeRange? period,
  }) {
    return DashboardState(
      selectedAccountId: selectedAccountId ?? this.selectedAccountId,
      transactions: transactions ?? this.transactions,
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
      metrics: metrics ?? this.metrics,
      period: period ?? this.period,
    );
  }
}

extension DashboardStateX on DashboardState {
  Category? getCategoryById(String? id) {
    if (id == null) return null;
    return categories.cast<Category?>().firstWhere(
      (c) => c?.id == id,
      orElse: () => null,
    );
  }

  Account? getAccountById(String? id) {
    if (id == null) return null;
    return accounts.cast<Account?>().firstWhere(
      (a) => a?.id == id,
      orElse: () => null,
    );
  }

  Tag? getTagById(String? id) {
    if (id == null) return null;
    return tags.cast<Tag?>().firstWhere((t) => t?.id == id, orElse: () => null);
  }
}
