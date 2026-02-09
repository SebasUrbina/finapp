// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tagsFamilyHash() => r'27dffb3d5a416cc207d855d10f9f4c5c259ef3a9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Family provider INTERNO
///
/// Copied from [_tagsFamily].
@ProviderFor(_tagsFamily)
const _tagsFamilyProvider = _TagsFamilyFamily();

/// Family provider INTERNO
///
/// Copied from [_tagsFamily].
class _TagsFamilyFamily extends Family<AsyncValue<List<Tag>>> {
  /// Family provider INTERNO
  ///
  /// Copied from [_tagsFamily].
  const _TagsFamilyFamily();

  /// Family provider INTERNO
  ///
  /// Copied from [_tagsFamily].
  _TagsFamilyProvider call(String userId) {
    return _TagsFamilyProvider(userId);
  }

  @override
  _TagsFamilyProvider getProviderOverride(
    covariant _TagsFamilyProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_tagsFamilyProvider';
}

/// Family provider INTERNO
///
/// Copied from [_tagsFamily].
class _TagsFamilyProvider extends AutoDisposeFutureProvider<List<Tag>> {
  /// Family provider INTERNO
  ///
  /// Copied from [_tagsFamily].
  _TagsFamilyProvider(String userId)
    : this._internal(
        (ref) => _tagsFamily(ref as _TagsFamilyRef, userId),
        from: _tagsFamilyProvider,
        name: r'_tagsFamilyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$tagsFamilyHash,
        dependencies: _TagsFamilyFamily._dependencies,
        allTransitiveDependencies: _TagsFamilyFamily._allTransitiveDependencies,
        userId: userId,
      );

  _TagsFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<Tag>> Function(_TagsFamilyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _TagsFamilyProvider._internal(
        (ref) => create(ref as _TagsFamilyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Tag>> createElement() {
    return _TagsFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _TagsFamilyProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _TagsFamilyRef on AutoDisposeFutureProviderRef<List<Tag>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _TagsFamilyProviderElement
    extends AutoDisposeFutureProviderElement<List<Tag>>
    with _TagsFamilyRef {
  _TagsFamilyProviderElement(super.provider);

  @override
  String get userId => (origin as _TagsFamilyProvider).userId;
}

String _$tagsHash() => r'7e1b1c76e79de3f32a2e47b510bca1c15f5aaae7';

/// Wrapper provider PÚBLICO
///
/// Copied from [tags].
@ProviderFor(tags)
final tagsProvider = AutoDisposeFutureProvider<List<Tag>>.internal(
  tags,
  name: r'tagsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tagsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TagsRef = AutoDisposeFutureProviderRef<List<Tag>>;
String _$transactionsFamilyHash() =>
    r'eaec77ef5cc222aedd96cdf59ed0b56109ea3cd3';

abstract class _$TransactionsFamily
    extends BuildlessAutoDisposeAsyncNotifier<List<Transaction>> {
  late final String userId;

  FutureOr<List<Transaction>> build(String userId);
}

/// Family provider INTERNO que recibe userId explícitamente
///
/// Copied from [TransactionsFamily].
@ProviderFor(TransactionsFamily)
const transactionsFamilyProvider = TransactionsFamilyFamily();

/// Family provider INTERNO que recibe userId explícitamente
///
/// Copied from [TransactionsFamily].
class TransactionsFamilyFamily extends Family<AsyncValue<List<Transaction>>> {
  /// Family provider INTERNO que recibe userId explícitamente
  ///
  /// Copied from [TransactionsFamily].
  const TransactionsFamilyFamily();

  /// Family provider INTERNO que recibe userId explícitamente
  ///
  /// Copied from [TransactionsFamily].
  TransactionsFamilyProvider call(String userId) {
    return TransactionsFamilyProvider(userId);
  }

  @override
  TransactionsFamilyProvider getProviderOverride(
    covariant TransactionsFamilyProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'transactionsFamilyProvider';
}

/// Family provider INTERNO que recibe userId explícitamente
///
/// Copied from [TransactionsFamily].
class TransactionsFamilyProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          TransactionsFamily,
          List<Transaction>
        > {
  /// Family provider INTERNO que recibe userId explícitamente
  ///
  /// Copied from [TransactionsFamily].
  TransactionsFamilyProvider(String userId)
    : this._internal(
        () => TransactionsFamily()..userId = userId,
        from: transactionsFamilyProvider,
        name: r'transactionsFamilyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$transactionsFamilyHash,
        dependencies: TransactionsFamilyFamily._dependencies,
        allTransitiveDependencies:
            TransactionsFamilyFamily._allTransitiveDependencies,
        userId: userId,
      );

  TransactionsFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<List<Transaction>> runNotifierBuild(
    covariant TransactionsFamily notifier,
  ) {
    return notifier.build(userId);
  }

  @override
  Override overrideWith(TransactionsFamily Function() create) {
    return ProviderOverride(
      origin: this,
      override: TransactionsFamilyProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TransactionsFamily, List<Transaction>>
  createElement() {
    return _TransactionsFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionsFamilyProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionsFamilyRef
    on AutoDisposeAsyncNotifierProviderRef<List<Transaction>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _TransactionsFamilyProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          TransactionsFamily,
          List<Transaction>
        >
    with TransactionsFamilyRef {
  _TransactionsFamilyProviderElement(super.provider);

  @override
  String get userId => (origin as TransactionsFamilyProvider).userId;
}

String _$transactionsHash() => r'e732858aae6c91db9e4e5942a35cc02a48dddacf';

/// Wrapper provider PÚBLICO (API sin cambios para widgets)
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
String _$accountsFamilyHash() => r'380be229f9f11ee03f55cddb98a21052fa7b550c';

abstract class _$AccountsFamily
    extends BuildlessAutoDisposeAsyncNotifier<List<Account>> {
  late final String userId;

  FutureOr<List<Account>> build(String userId);
}

/// Family provider INTERNO
///
/// Copied from [AccountsFamily].
@ProviderFor(AccountsFamily)
const accountsFamilyProvider = AccountsFamilyFamily();

/// Family provider INTERNO
///
/// Copied from [AccountsFamily].
class AccountsFamilyFamily extends Family<AsyncValue<List<Account>>> {
  /// Family provider INTERNO
  ///
  /// Copied from [AccountsFamily].
  const AccountsFamilyFamily();

  /// Family provider INTERNO
  ///
  /// Copied from [AccountsFamily].
  AccountsFamilyProvider call(String userId) {
    return AccountsFamilyProvider(userId);
  }

  @override
  AccountsFamilyProvider getProviderOverride(
    covariant AccountsFamilyProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'accountsFamilyProvider';
}

/// Family provider INTERNO
///
/// Copied from [AccountsFamily].
class AccountsFamilyProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<AccountsFamily, List<Account>> {
  /// Family provider INTERNO
  ///
  /// Copied from [AccountsFamily].
  AccountsFamilyProvider(String userId)
    : this._internal(
        () => AccountsFamily()..userId = userId,
        from: accountsFamilyProvider,
        name: r'accountsFamilyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$accountsFamilyHash,
        dependencies: AccountsFamilyFamily._dependencies,
        allTransitiveDependencies:
            AccountsFamilyFamily._allTransitiveDependencies,
        userId: userId,
      );

  AccountsFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<List<Account>> runNotifierBuild(covariant AccountsFamily notifier) {
    return notifier.build(userId);
  }

  @override
  Override overrideWith(AccountsFamily Function() create) {
    return ProviderOverride(
      origin: this,
      override: AccountsFamilyProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AccountsFamily, List<Account>>
  createElement() {
    return _AccountsFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountsFamilyProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountsFamilyRef on AutoDisposeAsyncNotifierProviderRef<List<Account>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _AccountsFamilyProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<AccountsFamily, List<Account>>
    with AccountsFamilyRef {
  _AccountsFamilyProviderElement(super.provider);

  @override
  String get userId => (origin as AccountsFamilyProvider).userId;
}

String _$accountsHash() => r'f148c52a87594690f0a0b68c3f8aa57181a0c448';

/// Wrapper provider PÚBLICO
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
String _$categoriesFamilyHash() => r'4bbe45c70d62f4844fe056347df91e54923d8408';

abstract class _$CategoriesFamily
    extends BuildlessAutoDisposeAsyncNotifier<List<Category>> {
  late final String userId;

  FutureOr<List<Category>> build(String userId);
}

/// Family provider INTERNO
///
/// Copied from [CategoriesFamily].
@ProviderFor(CategoriesFamily)
const categoriesFamilyProvider = CategoriesFamilyFamily();

/// Family provider INTERNO
///
/// Copied from [CategoriesFamily].
class CategoriesFamilyFamily extends Family<AsyncValue<List<Category>>> {
  /// Family provider INTERNO
  ///
  /// Copied from [CategoriesFamily].
  const CategoriesFamilyFamily();

  /// Family provider INTERNO
  ///
  /// Copied from [CategoriesFamily].
  CategoriesFamilyProvider call(String userId) {
    return CategoriesFamilyProvider(userId);
  }

  @override
  CategoriesFamilyProvider getProviderOverride(
    covariant CategoriesFamilyProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoriesFamilyProvider';
}

/// Family provider INTERNO
///
/// Copied from [CategoriesFamily].
class CategoriesFamilyProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<CategoriesFamily, List<Category>> {
  /// Family provider INTERNO
  ///
  /// Copied from [CategoriesFamily].
  CategoriesFamilyProvider(String userId)
    : this._internal(
        () => CategoriesFamily()..userId = userId,
        from: categoriesFamilyProvider,
        name: r'categoriesFamilyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoriesFamilyHash,
        dependencies: CategoriesFamilyFamily._dependencies,
        allTransitiveDependencies:
            CategoriesFamilyFamily._allTransitiveDependencies,
        userId: userId,
      );

  CategoriesFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<List<Category>> runNotifierBuild(
    covariant CategoriesFamily notifier,
  ) {
    return notifier.build(userId);
  }

  @override
  Override overrideWith(CategoriesFamily Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoriesFamilyProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CategoriesFamily, List<Category>>
  createElement() {
    return _CategoriesFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesFamilyProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoriesFamilyRef
    on AutoDisposeAsyncNotifierProviderRef<List<Category>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _CategoriesFamilyProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          CategoriesFamily,
          List<Category>
        >
    with CategoriesFamilyRef {
  _CategoriesFamilyProviderElement(super.provider);

  @override
  String get userId => (origin as CategoriesFamilyProvider).userId;
}

String _$categoriesHash() => r'23f6efcee6bd1b230b5ee55afd18789fd29bf090';

/// Wrapper provider PÚBLICO
///
/// Copied from [Categories].
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
String _$budgetsFamilyHash() => r'a6a675eb4813cf99aa8d304c061367a7e7ab98e8';

abstract class _$BudgetsFamily
    extends BuildlessAutoDisposeAsyncNotifier<List<Budget>> {
  late final String userId;

  FutureOr<List<Budget>> build(String userId);
}

/// Family provider INTERNO
///
/// Copied from [BudgetsFamily].
@ProviderFor(BudgetsFamily)
const budgetsFamilyProvider = BudgetsFamilyFamily();

/// Family provider INTERNO
///
/// Copied from [BudgetsFamily].
class BudgetsFamilyFamily extends Family<AsyncValue<List<Budget>>> {
  /// Family provider INTERNO
  ///
  /// Copied from [BudgetsFamily].
  const BudgetsFamilyFamily();

  /// Family provider INTERNO
  ///
  /// Copied from [BudgetsFamily].
  BudgetsFamilyProvider call(String userId) {
    return BudgetsFamilyProvider(userId);
  }

  @override
  BudgetsFamilyProvider getProviderOverride(
    covariant BudgetsFamilyProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'budgetsFamilyProvider';
}

/// Family provider INTERNO
///
/// Copied from [BudgetsFamily].
class BudgetsFamilyProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BudgetsFamily, List<Budget>> {
  /// Family provider INTERNO
  ///
  /// Copied from [BudgetsFamily].
  BudgetsFamilyProvider(String userId)
    : this._internal(
        () => BudgetsFamily()..userId = userId,
        from: budgetsFamilyProvider,
        name: r'budgetsFamilyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$budgetsFamilyHash,
        dependencies: BudgetsFamilyFamily._dependencies,
        allTransitiveDependencies:
            BudgetsFamilyFamily._allTransitiveDependencies,
        userId: userId,
      );

  BudgetsFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<List<Budget>> runNotifierBuild(covariant BudgetsFamily notifier) {
    return notifier.build(userId);
  }

  @override
  Override overrideWith(BudgetsFamily Function() create) {
    return ProviderOverride(
      origin: this,
      override: BudgetsFamilyProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BudgetsFamily, List<Budget>>
  createElement() {
    return _BudgetsFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BudgetsFamilyProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BudgetsFamilyRef on AutoDisposeAsyncNotifierProviderRef<List<Budget>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _BudgetsFamilyProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BudgetsFamily, List<Budget>>
    with BudgetsFamilyRef {
  _BudgetsFamilyProviderElement(super.provider);

  @override
  String get userId => (origin as BudgetsFamilyProvider).userId;
}

String _$budgetsHash() => r'ea1c33c70021b969311a173615dd8d901431f75d';

/// Wrapper provider PÚBLICO
///
/// Copied from [Budgets].
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
String _$personsFamilyHash() => r'8257eb5cd57f9456331482d361e62ca7f0d2411a';

abstract class _$PersonsFamily
    extends BuildlessAutoDisposeAsyncNotifier<List<Person>> {
  late final String userId;

  FutureOr<List<Person>> build(String userId);
}

/// Family provider INTERNO
///
/// Copied from [PersonsFamily].
@ProviderFor(PersonsFamily)
const personsFamilyProvider = PersonsFamilyFamily();

/// Family provider INTERNO
///
/// Copied from [PersonsFamily].
class PersonsFamilyFamily extends Family<AsyncValue<List<Person>>> {
  /// Family provider INTERNO
  ///
  /// Copied from [PersonsFamily].
  const PersonsFamilyFamily();

  /// Family provider INTERNO
  ///
  /// Copied from [PersonsFamily].
  PersonsFamilyProvider call(String userId) {
    return PersonsFamilyProvider(userId);
  }

  @override
  PersonsFamilyProvider getProviderOverride(
    covariant PersonsFamilyProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'personsFamilyProvider';
}

/// Family provider INTERNO
///
/// Copied from [PersonsFamily].
class PersonsFamilyProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PersonsFamily, List<Person>> {
  /// Family provider INTERNO
  ///
  /// Copied from [PersonsFamily].
  PersonsFamilyProvider(String userId)
    : this._internal(
        () => PersonsFamily()..userId = userId,
        from: personsFamilyProvider,
        name: r'personsFamilyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$personsFamilyHash,
        dependencies: PersonsFamilyFamily._dependencies,
        allTransitiveDependencies:
            PersonsFamilyFamily._allTransitiveDependencies,
        userId: userId,
      );

  PersonsFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<List<Person>> runNotifierBuild(covariant PersonsFamily notifier) {
    return notifier.build(userId);
  }

  @override
  Override overrideWith(PersonsFamily Function() create) {
    return ProviderOverride(
      origin: this,
      override: PersonsFamilyProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PersonsFamily, List<Person>>
  createElement() {
    return _PersonsFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonsFamilyProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PersonsFamilyRef on AutoDisposeAsyncNotifierProviderRef<List<Person>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _PersonsFamilyProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PersonsFamily, List<Person>>
    with PersonsFamilyRef {
  _PersonsFamilyProviderElement(super.provider);

  @override
  String get userId => (origin as PersonsFamilyProvider).userId;
}

String _$personsHash() => r'f71628785acab9128b2bb18fe184ca3dca0ab681';

/// Wrapper provider PÚBLICO
///
/// Copied from [Persons].
@ProviderFor(Persons)
final personsProvider =
    AutoDisposeAsyncNotifierProvider<Persons, List<Person>>.internal(
      Persons.new,
      name: r'personsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$personsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Persons = AutoDisposeAsyncNotifier<List<Person>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
