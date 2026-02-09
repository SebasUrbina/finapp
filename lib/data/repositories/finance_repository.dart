import 'package:finapp/domain/models/finance_models.dart';

// Los repositorios son los que pueden recibir uno o mas servicios y se encargan de "mapear"
// la data RAW a objetos.

// Repositories are the source of the truth for application data, and contain logic that relates to that data, like updating the data in response to new user events or polling for data from services. Repositories are responsible for synchronizing the data when offline capabilities are supported, managing retry logic, and caching data.

abstract class FinanceRepository {
  // CRUD - Todos los métodos reciben userId para hacer explícita la dependencia
  Future<List<Account>> getAccounts(String userId);
  Future<List<Transaction>> getTransactions(String userId);
  Future<List<Category>> getCategories(String userId);

  // Tags del usuario (los predefinidos están en código)
  Future<List<Tag>> getTags(String userId);
  Future<void> addTag(String userId, Tag tag);
  Future<void> updateTag(String userId, Tag tag);
  Future<void> deleteTag(String userId, String tagId);

  Future<List<Budget>> getBudgets(String userId);
  Future<void> addBudget(String userId, Budget budget);
  Future<void> updateBudget(String userId, Budget budget);
  Future<void> deleteBudget(String userId, String budgetId);

  Future<List<Person>> getPersons(String userId);
  // Crud transaction
  Future<void> addTransaction(String userId, Transaction tx);
  Future<void> updateTransaction(String userId, Transaction tx);
  Future<void> deleteTransaction(String userId, String transactionId);
  // Crud category
  Future<void> addCategory(String userId, Category cat);
  Future<void> updateCategory(String userId, Category cat);
  Future<void> deleteCategory(String userId, String categoryId);
  // Crud account
  Future<void> addAccount(String userId, Account acc);
  Future<void> updateAccount(String userId, Account acc);
  Future<void> deleteAccount(String userId, String accountId);
  // Crud person
  Future<void> addPerson(String userId, Person person);
  Future<void> updatePerson(String userId, Person person);
  Future<void> deletePerson(String userId, String personId);
  // Load default categories for new users
  Future<void> loadDefaultCategories(String userId);
}

// Transactions repository
abstract class TransactionsRepository {
  List<Transaction> getTransactions();
  Future<void> addTransaction(Transaction tx);
}

// Accounts repository
abstract class AccountsRepository {
  List<Account> getAccounts();
  Future<void> addAccount(Account acc);
}

// Categories repository
abstract class CategoriesRepository {
  List<Category> getCategories();
  Future<void> addCategory(Category cat);
}
