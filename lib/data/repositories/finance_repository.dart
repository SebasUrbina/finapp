import 'package:finapp/domain/models/finance_models.dart';

// Los repositorios son los que pueden recibir uno o mas servicios y se encargan de "mapear"
// la data RAW a objetos.

// Repositories are the source of the truth for application data, and contain logic that relates to that data, like updating the data in response to new user events or polling for data from services. Repositories are responsible for synchronizing the data when offline capabilities are supported, managing retry logic, and caching data.

abstract class FinanceRepository {
  // CRUD
  List<Account> getAccounts();
  List<Transaction> getTransactions();
  List<Category> getCategories();
  List<Tag> getTags();
  List<Budget> getBudgets();
  List<Person> getPersons();
  // Crud transaction
  Future<void> addTransaction(Transaction tx);
  Future<void> updateTransaction(Transaction tx);
  Future<void> deleteTransaction(String transactionId);
  // Crud category
  Future<void> addCategory(Category cat);
  Future<void> updateCategory(Category cat);
  Future<void> deleteCategory(String categoryId);
  // Crud account
  Future<void> addAccount(Account acc);
  Future<void> updateAccount(Account acc);
  Future<void> deleteAccount(String accountId);
  // Crud person
  Future<void> addPerson(Person person);
  Future<void> updatePerson(Person person);
  Future<void> deletePerson(String personId);
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
