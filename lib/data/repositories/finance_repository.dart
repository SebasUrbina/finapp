import 'package:carenine/core/models/finance_models.dart';

abstract class FinanceRepository {
  List<Account> getAccounts();
  List<Transaction> getTransactions();
  List<Category> getCategories();
  List<Tag> getTags();
  List<Budget> getBudgets();
  Future<void> addTransaction(Transaction tx);
}
