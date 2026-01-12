import 'package:finapp/data/services/local_data_service.dart';
import 'package:finapp/data/repositories/finance_repository.dart';
import 'package:finapp/domain/models/finance_models.dart';

class FinanceRepositoryLocal implements FinanceRepository {
  // Note: deberiamos usar el servicio como input del repositorio.
  // FinanceRepositoryLocal({required LocalDataService localDataService}) : _localDataService = localDataService;
  // final LocalDataService _localDataService;

  @override
  List<Account> getAccounts() => List.from(LocalDataService.accounts);

  @override
  List<Transaction> getTransactions() =>
      List.from(LocalDataService.transactions);

  @override
  List<Category> getCategories() => List.from(LocalDataService.categories);

  @override
  List<Tag> getTags() => List.from(LocalDataService.tags);

  @override
  List<Budget> getBudgets() => List.from(LocalDataService.budgets);

  @override
  Future<void> addTransaction(Transaction tx) async {
    LocalDataService.transactions.add(tx);
  }
}

// Mockup para transacciones
class MockTransactionsRepository implements TransactionsRepository {
  @override
  List<Transaction> getTransactions() => LocalDataService.transactions;

  @override
  Future<void> addTransaction(Transaction tx) async {
    LocalDataService.transactions.add(tx);
  }
}
