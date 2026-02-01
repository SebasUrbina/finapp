import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/data/repositories/finance_repository.dart';
import 'package:finapp/data/repositories/finance_repository_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Los providers de riverpod son globales, es decir, se comparten entre todas las pantallas.
// Por lo tanto, no es necesario pasarlos como parámetros a las pantallas.
// El objetivo es que cada pantalla pueda acceder a los datos que necesita sin tener que pasarlos como parámetros.

/// Repositorio Global (mock hoy, backend mañana)
final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepositoryLocal();
});

// Transactions provider
final transactionsProvider = Provider<List<Transaction>>((ref) {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getTransactions();
});

// Accounts provider
final accountsProvider = Provider<List<Account>>((ref) {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getAccounts();
});

// Categories provider
final categoriesProvider = Provider<List<Category>>((ref) {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getCategories();
});

// Tags provider
final tagsProvider = Provider<List<Tag>>((ref) {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getTags();
});

// Budgets provider
final budgetsProvider = Provider<List<Budget>>((ref) {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getBudgets();
});

// Persons provider (global state for shared expenses)
final personsProvider = Provider<List<Person>>((ref) {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getPersons();
});
