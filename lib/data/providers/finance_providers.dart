import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/data/repositories/finance_repository.dart';
import 'package:finapp/data/repositories/finance_repository_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'finance_providers.g.dart';

/// Repositorio Global
final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepositoryLocal();
});

/// Transactions Provider (Converted to AsyncNotifier for silent reload)
@riverpod
class Transactions extends _$Transactions {
  @override
  Future<List<Transaction>> build() async {
    final repo = ref.watch(financeRepositoryProvider);
    return repo.getTransactions();
  }

  /// Refreshes the data without emitting a loading state (Silent Refresh)
  /// or dealing with disposal.
  Future<void> reload() async {
    final repo = ref.read(financeRepositoryProvider);
    // Silent update: Fetch first, then simple state update
    // If we wanted to show loading indicator over content, we'd use:
    // state = const AsyncLoading<List<Transaction>>().copyWithPrevious(state);

    // For now, let's try strict silent update to minimize flicker.
    // If an error occurs, it will show error.
    state = await AsyncValue.guard(() => repo.getTransactions());
  }
}

/// Accounts Provider (Converted to AsyncNotifier)
@riverpod
class Accounts extends _$Accounts {
  @override
  Future<List<Account>> build() async {
    final repo = ref.watch(financeRepositoryProvider);
    return repo.getAccounts();
  }

  Future<void> reload() async {
    final repo = ref.read(financeRepositoryProvider);
    state = await AsyncValue.guard(() => repo.getAccounts());
  }
}

// Categories provider (Already AsyncNotifier)
@riverpod
class Categories extends _$Categories {
  @override
  Future<List<Category>> build() async {
    final repo = ref.watch(financeRepositoryProvider);
    return repo.getCategories();
  }

  Future<void> addCategory(Category category) async {
    final repo = ref.read(financeRepositoryProvider);
    await repo.addCategory(category);
    // Use manual reload instead of invalidateSelf to avoid full reset if possible,
    // but invalidateSelf is standard for self-refresh.
    // Ideally we'd just re-fetch:
    state = await AsyncValue.guard(() => repo.getCategories());
  }

  Future<void> updateCategory(Category category) async {
    final repo = ref.read(financeRepositoryProvider);
    await repo.updateCategory(category);
    state = await AsyncValue.guard(() => repo.getCategories());
  }

  Future<void> deleteCategory(String categoryId) async {
    final repo = ref.read(financeRepositoryProvider);
    await repo.deleteCategory(categoryId);
    state = await AsyncValue.guard(() => repo.getCategories());
  }
}

// Tags provider
final tagsProvider = FutureProvider<List<Tag>>((ref) {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.getTags();
});

// Budgets provider
// Left as FutureProvider for now, or convert if needed.
// Ideally convert for consistency.
@riverpod
class Budgets extends _$Budgets {
  @override
  Future<List<Budget>> build() async {
    final repo = ref.watch(financeRepositoryProvider);
    return repo.getBudgets();
  }

  Future<void> reload() async {
    final repo = ref.read(financeRepositoryProvider);
    state = await AsyncValue.guard(() => repo.getBudgets());
  }
}

// Persons provider (Already AsyncNotifier, logic ok)
class PersonsNotifier extends AsyncNotifier<List<Person>> {
  @override
  Future<List<Person>> build() async {
    final repo = ref.watch(financeRepositoryProvider);
    return repo.getPersons();
  }

  Future<void> addPerson(Person person) async {
    final repo = ref.read(financeRepositoryProvider);
    await repo.addPerson(person);
    state = await AsyncValue.guard(() => repo.getPersons());
  }

  Future<void> updatePerson(Person person) async {
    final repo = ref.read(financeRepositoryProvider);
    await repo.updatePerson(person);
    state = await AsyncValue.guard(() => repo.getPersons());
  }

  Future<void> deletePerson(String personId) async {
    final repo = ref.read(financeRepositoryProvider);
    await repo.deletePerson(personId);
    state = await AsyncValue.guard(() => repo.getPersons());
  }
}

final personsProvider = AsyncNotifierProvider<PersonsNotifier, List<Person>>(
  PersonsNotifier.new,
);
