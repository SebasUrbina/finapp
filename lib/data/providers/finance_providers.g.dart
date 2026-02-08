// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsHash() => r'1c52bd5649fe6a6eb89f2b1bc8835bf3f48ab95a';

/// Transactions Provider (Converted to AsyncNotifier for silent reload)
///
/// Copied from [Transactions].
@ProviderFor(Transactions)
final transactionsProvider =
    AutoDisposeAsyncNotifierProvider<Transactions, List<Transaction>>.internal(
      Transactions.new,
      name: r'transactionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Transactions = AutoDisposeAsyncNotifier<List<Transaction>>;
String _$accountsHash() => r'e44f48e39b48892b18be4cf425c8bc553a032065';

/// Accounts Provider (Converted to AsyncNotifier)
///
/// Copied from [Accounts].
@ProviderFor(Accounts)
final accountsProvider =
    AutoDisposeAsyncNotifierProvider<Accounts, List<Account>>.internal(
      Accounts.new,
      name: r'accountsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Accounts = AutoDisposeAsyncNotifier<List<Account>>;
String _$categoriesHash() => r'5e67f4494d8bb35ba672e62d768a41017ba90652';

/// See also [Categories].
@ProviderFor(Categories)
final categoriesProvider =
    AutoDisposeAsyncNotifierProvider<Categories, List<Category>>.internal(
      Categories.new,
      name: r'categoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Categories = AutoDisposeAsyncNotifier<List<Category>>;
String _$budgetsHash() => r'9b48a19ac0b84551924a7c3ff4a472ce9b622f6b';

/// See also [Budgets].
@ProviderFor(Budgets)
final budgetsProvider =
    AutoDisposeAsyncNotifierProvider<Budgets, List<Budget>>.internal(
      Budgets.new,
      name: r'budgetsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$budgetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Budgets = AutoDisposeAsyncNotifier<List<Budget>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
