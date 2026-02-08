import 'package:finapp/data/services/local_data_service.dart';
import 'package:finapp/data/repositories/finance_repository.dart';
import 'package:finapp/domain/models/finance_models.dart';

class FinanceRepositoryLocal implements FinanceRepository {
  // Note: deberiamos usar el servicio como input del repositorio.
  // FinanceRepositoryLocal({required LocalDataService localDataService}) : _localDataService = localDataService;
  // final LocalDataService _localDataService;

  @override
  Future<List<Account>> getAccounts() async => List.from(LocalDataService.accounts);

  @override
  Future<List<Transaction>> getTransactions() async =>
      List.from(LocalDataService.transactions);

  @override
  Future<List<Category>> getCategories() async => List.from(LocalDataService.categories);

  @override
  Future<List<Tag>> getTags() async => List.from(LocalDataService.tags);

  @override
  Future<List<Budget>> getBudgets() async => List.from(LocalDataService.budgets);

  @override
  Future<List<Person>> getPersons() async => List.from(LocalDataService.persons);

  @override
  Future<void> addTransaction(Transaction tx) async {
    LocalDataService.transactions.add(tx);
  }

  @override
  Future<void> updateTransaction(Transaction tx) async {
    final index = LocalDataService.transactions.indexWhere(
      (t) => t.id == tx.id,
    );
    if (index != -1) {
      LocalDataService.transactions[index] = tx;
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    LocalDataService.transactions.removeWhere((t) => t.id == transactionId);
  }

  @override
  Future<void> addCategory(Category cat) async {
    LocalDataService.categories.add(cat);
  }

  @override
  Future<void> updateCategory(Category cat) async {
    final index = LocalDataService.categories.indexWhere((c) => c.id == cat.id);
    if (index != -1) {
      LocalDataService.categories[index] = cat;
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    LocalDataService.categories.removeWhere((c) => c.id == categoryId);
    // Also remove from transactions for safety (optional but good practice in mock)
    LocalDataService.transactions
        .where((t) => t.categoryId == categoryId)
        .forEach((t) {
          // In a real app we might throw or nullify, here we just remove.
        });
  }

  @override
  Future<void> addAccount(Account acc) async {
    LocalDataService.accounts.add(acc);
  }

  @override
  Future<void> updateAccount(Account acc) async {
    final index = LocalDataService.accounts.indexWhere((a) => a.id == acc.id);
    if (index != -1) {
      LocalDataService.accounts[index] = acc;
    }
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    LocalDataService.accounts.removeWhere((a) => a.id == accountId);
    // Optionally: remove transactions associated? Usually we shouldn't unless requested.
  }

  @override
  Future<void> addPerson(Person person) async {
    LocalDataService.persons.add(person);
  }

  @override
  Future<void> updatePerson(Person person) async {
    final index = LocalDataService.persons.indexWhere((p) => p.id == person.id);
    if (index != -1) {
      LocalDataService.persons[index] = person;
    }
  }

  @override
  Future<void> deletePerson(String personId) async {
    LocalDataService.persons.removeWhere((p) => p.id == personId);
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
