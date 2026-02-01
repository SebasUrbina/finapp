import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/utils/date_ranges.dart';
import 'dashboard_base_providers.dart';
import 'dashboard_filter_providers.dart';

final dashboardTotalIncomeProvider = Provider<Money>((ref) {
  final txs = ref
      .watch(dashboardFilteredTransactionsProvider)
      .where((t) => t.type == TransactionType.income);

  return txs.isEmpty
      ? const Money(0)
      : txs.map((t) => t.amount).reduce((a, b) => a + b);
});

final dashboardTotalExpensesProvider = Provider<Money>((ref) {
  final txs = ref
      .watch(dashboardFilteredTransactionsProvider)
      .where((t) => t.type == TransactionType.expense);

  return txs.isEmpty
      ? const Money(0)
      : txs.map((t) => t.amount).reduce((a, b) => a + b);
});

final dashboardPreviousTotalExpensesProvider = Provider<Money>((ref) {
  final transactions = ref.watch(dashboardTransactionsProvider);
  final range = ref.watch(dashboardPreviousPeriodRangeProvider);
  final accountId = ref.watch(dashboardSelectedAccountIdProvider);

  final txs = transactions.where((t) {
    if (t.type != TransactionType.expense) return false;
    if (!isWithin(t.date, range)) return false;
    if (accountId != null && t.accountId != accountId) return false;
    return true;
  });

  return txs.isEmpty
      ? const Money(0)
      : txs.map((t) => t.amount).reduce((a, b) => a + b);
});

final dashboardBalanceProvider = Provider<Money>((ref) {
  final income = ref.watch(dashboardTotalIncomeProvider);
  final expenses = ref.watch(dashboardTotalExpensesProvider);
  return Money(income.value - expenses.value);
});

final dashboardSpendingChangePercentageProvider = Provider<double>((ref) {
  final current = ref.watch(dashboardTotalExpensesProvider).value;
  final previous = ref.watch(dashboardPreviousTotalExpensesProvider).value;
  if (previous == 0) return 0.0;
  return ((current - previous) / previous) * 100;
});

final dashboardSavingsRateProvider = Provider<double>((ref) {
  final income = ref.watch(dashboardTotalIncomeProvider).value;
  final expenses = ref.watch(dashboardTotalExpensesProvider).value;
  if (income <= 0) return 0.0;
  final savings = income - expenses;
  return (savings / income) * 100;
});

final dashboardTransactionCountProvider = Provider<int>((ref) {
  return ref.watch(dashboardFilteredTransactionsProvider).length;
});

final dashboardAverageDailySpendingProvider = Provider<Money>((ref) {
  final expenses = ref.watch(dashboardTotalExpensesProvider);
  final range = ref.watch(dashboardPeriodRangeProvider);
  final days = range.end.difference(range.start).inDays.clamp(1, 365);
  return Money(expenses.value / days);
});

final dashboardExpensesByCategoryProvider = Provider<Map<Category, Money>>((
  ref,
) {
  final transactions = ref
      .watch(dashboardFilteredTransactionsProvider)
      .where((t) => t.type == TransactionType.expense);
  final categories = ref.watch(dashboardCategoriesProvider);

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
});

final dashboardTopCategoryByTagProvider =
    Provider.family<MapEntry<Category, Money>?, String?>((ref, tagId) {
      final transactions = ref
          .watch(dashboardFilteredTransactionsProvider)
          .where((t) => t.type == TransactionType.expense);
      final categories = ref.watch(dashboardCategoriesProvider);

      final filteredByTag = tagId == null
          ? transactions
          : transactions.where((t) {
              try {
                final category = categories.firstWhere(
                  (c) => c.id == t.categoryId,
                );
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
    });
