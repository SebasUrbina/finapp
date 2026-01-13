import 'package:finapp/domain/models/finance_models.dart';

class TransactionSearchState {
  final String searchQuery;
  final List<Transaction> allTransactions;
  final List<Category> categories;
  final List<Account> accounts;

  const TransactionSearchState({
    this.searchQuery = '',
    required this.allTransactions,
    required this.categories,
    required this.accounts,
  });

  TransactionSearchState copyWith({
    String? searchQuery,
    List<Transaction>? allTransactions,
    List<Category>? categories,
    List<Account>? accounts,
  }) {
    return TransactionSearchState(
      searchQuery: searchQuery ?? this.searchQuery,
      allTransactions: allTransactions ?? this.allTransactions,
      categories: categories ?? this.categories,
      accounts: accounts ?? this.accounts,
    );
  }

  /// Get filtered transactions based on search query
  List<Transaction> get filteredTransactions {
    if (searchQuery.isEmpty) {
      return allTransactions;
    }

    final query = searchQuery.toLowerCase();
    return allTransactions.where((transaction) {
      // Search by description
      if (transaction.description?.toLowerCase().contains(query) ?? false) {
        return true;
      }

      // Search by category name
      final category = categories
          .where((c) => c.id == transaction.categoryId)
          .firstOrNull;
      if (category?.name.toLowerCase().contains(query) ?? false) {
        return true;
      }

      // Search by account name
      final account = accounts
          .where((a) => a.id == transaction.accountId)
          .firstOrNull;
      if (account?.name.toLowerCase().contains(query) ?? false) {
        return true;
      }

      // Search by amount
      final amountStr = transaction.amount.value.toString();
      if (amountStr.contains(query)) {
        return true;
      }

      return false;
    }).toList();
  }
}
