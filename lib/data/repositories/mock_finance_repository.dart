import 'package:carenine/data/mock/mock_data.dart';
import 'package:carenine/data/repositories/finance_repository.dart';
import 'package:carenine/core/models/finance_models.dart';

class MockFinanceRepository implements FinanceRepository {
  @override
  List<Account> getAccounts() => MockData.accounts;

  @override
  List<Transaction> getTransactions() => MockData.transactions;

  @override
  List<Category> getCategories() => MockData.categories;

  @override
  List<Tag> getTags() => MockData.tags;

  @override
  List<Budget> getBudgets() => MockData.budgets;

  @override
  Future<void> addTransaction(Transaction tx) async {
    MockData.transactions.add(tx);
  }
}
