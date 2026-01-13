import 'package:finapp/features/dashboard/transaction_search/transaction_search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionSearchController
    extends StateNotifier<TransactionSearchState> {
  TransactionSearchController(TransactionSearchState initialState)
    : super(initialState);

  /// Update search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Clear search query
  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }
}
