import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/data/repositories/finance_repository.dart';
import 'package:finapp/data/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:finapp/data/repositories/finance_repository_firebase.dart';

part 'finance_providers.g.dart';

/// Repositorio Global
final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepositoryFirebase();
});

// ============================================================================
// TRANSACTIONS
// ============================================================================

/// Family provider INTERNO que recibe userId explícitamente
@riverpod
class TransactionsFamily extends _$TransactionsFamily {
  @override
  Future<List<Transaction>> build(String userId) async { 
    final repo = ref.watch(financeRepositoryProvider);
    return repo.getTransactions(userId);
  }

  Future<void> reload() async {
    final repo = ref.read(financeRepositoryProvider);
    state = await AsyncValue.guard(() => repo.getTransactions(userId));
  }
}

/// Wrapper provider PÚBLICO (API sin cambios para widgets)
@riverpod
class Transactions extends _$Transactions {
  @override
  Future<List<Transaction>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    return ref.watch(transactionsFamilyProvider(userId).future);
  }

  Future<void> reload() async {
    final userId = ref.read(currentUserIdProvider);
    await ref.read(transactionsFamilyProvider(userId).notifier).reload();
  }
}

// ============================================================================
// ACCOUNTS
// ============================================================================

/// Family provider INTERNO
@riverpod
class AccountsFamily extends _$AccountsFamily {
  @override
  Future<List<Account>> build(String userId) async {
    final repo = ref.watch(financeRepositoryProvider);
    return repo.getAccounts(userId);
  }

  Future<void> reload() async {
    final repo = ref.read(financeRepositoryProvider);
    state = await AsyncValue.guard(() => repo.getAccounts(userId));
  }
}

/// Wrapper provider PÚBLICO
@riverpod
class Accounts extends _$Accounts {
  @override
  Future<List<Account>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    return ref.watch(accountsFamilyProvider(userId).future);
  }

  Future<void> reload() async {
    final userId = ref.read(currentUserIdProvider);
    await ref.read(accountsFamilyProvider(userId).notifier).reload();
  }
}

// ============================================================================
// CATEGORIES
// ============================================================================

/// Family provider INTERNO
@riverpod
class CategoriesFamily extends _$CategoriesFamily {
  @override
  Future<List<Category>> build(String userId) async {
    final repo = ref.watch(financeRepositoryProvider);
    return repo.getCategories(userId);
  }

  Future<void> addCategory(Category category) async {
    final repo = ref.read(financeRepositoryProvider);
    await repo.addCategory(userId, category);
    state = await AsyncValue.guard(() => repo.getCategories(userId));
  }

  Future<void> updateCategory(Category category) async {
    final repo = ref.read(financeRepositoryProvider);
    await repo.updateCategory(userId, category);
    state = await AsyncValue.guard(() => repo.getCategories(userId));
  }

  Future<void> deleteCategory(String categoryId) async {
    final repo = ref.read(financeRepositoryProvider);
    await repo.deleteCategory(userId, categoryId);
    state = await AsyncValue.guard(() => repo.getCategories(userId));
  }
}

/// Wrapper provider PÚBLICO
@riverpod
class Categories extends _$Categories {
  @override
  Future<List<Category>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    return ref.watch(categoriesFamilyProvider(userId).future);
  }

  Future<void> addCategory(Category category) async {
    final userId = ref.read(currentUserIdProvider);
    await ref
        .read(categoriesFamilyProvider(userId).notifier)
        .addCategory(category);
  }

  Future<void> updateCategory(Category category) async {
    final userId = ref.read(currentUserIdProvider);
    await ref
        .read(categoriesFamilyProvider(userId).notifier)
        .updateCategory(category);
  }

  Future<void> deleteCategory(String categoryId) async {
    final userId = ref.read(currentUserIdProvider);
    await ref
        .read(categoriesFamilyProvider(userId).notifier)
        .deleteCategory(categoryId);
  }
}

// ============================================================================
// TAGS
// ============================================================================

/// Family provider INTERNO
@riverpod
Future<List<Tag>> _tagsFamily(Ref ref, String userId) async {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getTags(userId);
}

/// Wrapper provider PÚBLICO
@riverpod
Future<List<Tag>> tags(Ref ref) async {
  final userId = ref.watch(currentUserIdProvider);
  return ref.watch(_tagsFamilyProvider(userId).future);
}

// ============================================================================
// BUDGETS
// ============================================================================

/// Family provider INTERNO
@riverpod
class BudgetsFamily extends _$BudgetsFamily {
  @override
  Future<List<Budget>> build(String userId) async {
    final repo = ref.watch(financeRepositoryProvider);
    return repo.getBudgets(userId);
  }

  Future<void> reload() async {
    final repo = ref.read(financeRepositoryProvider);
    state = await AsyncValue.guard(() => repo.getBudgets(userId));
  }
}

/// Wrapper provider PÚBLICO
@riverpod
class Budgets extends _$Budgets {
  @override
  Future<List<Budget>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    return ref.watch(budgetsFamilyProvider(userId).future);
  }

  Future<void> reload() async {
    final userId = ref.read(currentUserIdProvider);
    await ref.read(budgetsFamilyProvider(userId).notifier).reload();
  }
}

// ============================================================================
// PERSONS
// ============================================================================

/// Family provider INTERNO
@riverpod
class PersonsFamily extends _$PersonsFamily {
  @override
  Future<List<Person>> build(String userId) async {
    final repo = ref.watch(financeRepositoryProvider);
    return repo.getPersons(userId);
  }

  Future<void> addPerson(Person person) async {
    final repo = ref.read(financeRepositoryProvider);
    await repo.addPerson(userId, person);
    state = await AsyncValue.guard(() => repo.getPersons(userId));
  }

  Future<void> updatePerson(Person person) async {
    final repo = ref.read(financeRepositoryProvider);
    await repo.updatePerson(userId, person);
    state = await AsyncValue.guard(() => repo.getPersons(userId));
  }

  Future<void> deletePerson(String personId) async {
    final repo = ref.read(financeRepositoryProvider);
    await repo.deletePerson(userId, personId);
    state = await AsyncValue.guard(() => repo.getPersons(userId));
  }
}

/// Wrapper provider PÚBLICO
@riverpod
class Persons extends _$Persons {
  @override
  Future<List<Person>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    return ref.watch(personsFamilyProvider(userId).future);
  }

  Future<void> addPerson(Person person) async {
    final userId = ref.read(currentUserIdProvider);
    await ref.read(personsFamilyProvider(userId).notifier).addPerson(person);
  }

  Future<void> updatePerson(Person person) async {
    final userId = ref.read(currentUserIdProvider);
    await ref
        .read(personsFamilyProvider(userId).notifier)
        .updatePerson(person);
  }

  Future<void> deletePerson(String personId) async {
    final userId = ref.read(currentUserIdProvider);
    await ref
        .read(personsFamilyProvider(userId).notifier)
        .deletePerson(personId);
  }
}
