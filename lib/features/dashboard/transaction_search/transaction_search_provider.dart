import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/dashboard/transaction_search/transaction_search_controller.dart';
import 'package:finapp/features/dashboard/transaction_search/transaction_search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Provider factory for transaction search
/// This creates a new provider instance for each modal
final transactionSearchProvider =
    StateNotifierProvider.family<
      TransactionSearchController,
      TransactionSearchState,
      TransactionSearchParams
    >((ref, params) {
      return TransactionSearchController(
        TransactionSearchState(
          allTransactions: params.transactions,
          categories: params.categories,
          accounts: params.accounts,
        ),
      );
    });

/// Provider for grouped transactions (derived data)
final groupedTransactionsProvider =
    Provider.family<Map<String, List<Transaction>>, TransactionSearchParams>((
      ref,
      params,
    ) {
      final state = ref.watch(transactionSearchProvider(params));
      final Map<String, List<Transaction>> grouped = {};
      final dateFormat = DateFormat('MMMM yyyy', 'es_ES');

      for (final transaction in state.filteredTransactions) {
        final monthKey = dateFormat.format(transaction.date);
        if (!grouped.containsKey(monthKey)) {
          grouped[monthKey] = [];
        }
        grouped[monthKey]!.add(transaction);
      }

      // Sort transactions within each month by date (most recent first)
      for (final key in grouped.keys) {
        grouped[key]!.sort((a, b) => b.date.compareTo(a.date));
      }

      return grouped;
    });

/// Helper provider to get category by ID
final categoryByIdProvider =
    Provider.family<
      Category?,
      ({TransactionSearchParams params, String? categoryId})
    >((ref, args) {
      if (args.categoryId == null) return null;
      final state = ref.watch(transactionSearchProvider(args.params));
      return state.categories.where((c) => c.id == args.categoryId).firstOrNull;
    });

/// Helper provider to get account by ID
final accountByIdProvider =
    Provider.family<
      Account?,
      ({TransactionSearchParams params, String accountId})
    >((ref, args) {
      final state = ref.watch(transactionSearchProvider(args.params));
      return state.accounts.where((a) => a.id == args.accountId).firstOrNull;
    });

/// Parameters for the transaction search provider
class TransactionSearchParams {
  final List<Transaction> transactions;
  final List<Category> categories;
  final List<Account> accounts;

  const TransactionSearchParams({
    required this.transactions,
    required this.categories,
    required this.accounts,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionSearchParams &&
        other.transactions == transactions &&
        other.categories == categories &&
        other.accounts == accounts;
  }

  @override
  int get hashCode =>
      transactions.hashCode ^ categories.hashCode ^ accounts.hashCode;
}
