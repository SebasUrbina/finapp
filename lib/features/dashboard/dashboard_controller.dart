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

  // ========== Helper Getters (Simplified) ==========

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

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
      final repo = ref.watch(financeRepositoryProvider);
      return DashboardController(repo);
    });
