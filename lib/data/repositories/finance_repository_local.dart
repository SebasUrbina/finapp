import 'package:finapp/data/services/local_data_service.dart';
import 'package:finapp/data/repositories/finance_repository.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/domain/models/default_categories.dart';

class FinanceRepositoryLocal implements FinanceRepository {
  // Note: deberiamos usar el servicio como input del repositorio.
  // FinanceRepositoryLocal({required LocalDataService localDataService}) : _localDataService = localDataService;
  // final LocalDataService _localDataService;

  @override
  Future<List<Account>> getAccounts(String userId) async =>
      List.from(LocalDataService.accounts);

  @override
  Future<List<Transaction>> getTransactions(String userId) async =>
      List.from(LocalDataService.transactions);

  @override
  Future<List<Category>> getCategories(String userId) async =>
      List.from(LocalDataService.categories);

  @override
  Future<List<Tag>> getTags(String userId) async =>
      List.from(LocalDataService.tags);

  @override
  Future<void> addTag(String userId, Tag tag) async {
    LocalDataService.tags.add(tag);
  }

  @override
  Future<void> updateTag(String userId, Tag tag) async {
    final index = LocalDataService.tags.indexWhere((t) => t.id == tag.id);
    if (index != -1) {
      LocalDataService.tags[index] = tag;
    }
  }

  @override
  Future<void> deleteTag(String userId, String tagId) async {
    LocalDataService.tags.removeWhere((t) => t.id == tagId);
  }

  @override
  Future<List<Budget>> getBudgets(String userId) async =>
      List.from(LocalDataService.budgets);

  @override
  Future<void> addBudget(String userId, Budget budget) async {
    LocalDataService.budgets.add(budget);
  }

  @override
  Future<void> updateBudget(String userId, Budget budget) async {
    final index = LocalDataService.budgets.indexWhere((b) => b.id == budget.id);
    if (index != -1) {
      LocalDataService.budgets[index] = budget;
    }
  }

  @override
  Future<void> deleteBudget(String userId, String budgetId) async {
    LocalDataService.budgets.removeWhere((b) => b.id == budgetId);
  }

  @override
  Future<List<Person>> getPersons(String userId) async =>
      List.from(LocalDataService.persons);

  @override
  Future<void> addTransaction(String userId, Transaction tx) async {
    LocalDataService.transactions.add(tx);
  }

  @override
  Future<void> updateTransaction(String userId, Transaction tx) async {
    final index = LocalDataService.transactions.indexWhere(
      (t) => t.id == tx.id,
    );
    if (index != -1) {
      LocalDataService.transactions[index] = tx;
    }
  }

  @override
  Future<void> deleteTransaction(String userId, String transactionId) async {
    LocalDataService.transactions.removeWhere((t) => t.id == transactionId);
  }

  @override
  Future<void> addCategory(String userId, Category cat) async {
    LocalDataService.categories.add(cat);
  }

  @override
  Future<void> updateCategory(String userId, Category cat) async {
    final index = LocalDataService.categories.indexWhere((c) => c.id == cat.id);
    if (index != -1) {
      LocalDataService.categories[index] = cat;
    }
  }

  @override
  Future<void> deleteCategory(String userId, String categoryId) async {
    LocalDataService.categories.removeWhere((c) => c.id == categoryId);
    // Also remove from transactions for safety (optional but good practice in mock)
    LocalDataService.transactions
        .where((t) => t.categoryId == categoryId)
        .forEach((t) {
          // In a real app we might throw or nullify, here we just remove.
        });
  }

  @override
  Future<void> addAccount(String userId, Account acc) async {
    LocalDataService.accounts.add(acc);
  }

  @override
  Future<void> updateAccount(String userId, Account acc) async {
    final index = LocalDataService.accounts.indexWhere((a) => a.id == acc.id);
    if (index != -1) {
      LocalDataService.accounts[index] = acc;
    }
  }

  @override
  Future<void> deleteAccount(String userId, String accountId) async {
    LocalDataService.accounts.removeWhere((a) => a.id == accountId);
    // Optionally: remove transactions associated? Usually we shouldn't unless requested.
  }

  @override
  Future<void> addPerson(String userId, Person person) async {
    LocalDataService.persons.add(person);
  }

  @override
  Future<void> updatePerson(String userId, Person person) async {
    final index = LocalDataService.persons.indexWhere((p) => p.id == person.id);
    if (index != -1) {
      LocalDataService.persons[index] = person;
    }
  }

  @override
  Future<void> deletePerson(String userId, String personId) async {
    LocalDataService.persons.removeWhere((p) => p.id == personId);
  }

  @override
  Future<void> loadDefaultCategories(String userId) async {
    // Only load if categories are empty to avoid duplicates
    if (LocalDataService.categories.isEmpty) {
      LocalDataService.categories.addAll(
        DefaultCategories.predefinedCategories,
      );
    }
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
