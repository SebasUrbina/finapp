import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/data/repositories/finance_repository.dart';
import 'package:finapp/data/repositories/finance_repository_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
