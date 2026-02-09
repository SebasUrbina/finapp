// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_edit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionEditControllerHash() =>
    r'6a5fae982eab8e0c5b7288d0fa0427301683b2aa';

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

abstract class _$TransactionEditController
    extends BuildlessAutoDisposeAsyncNotifier<TransactionEditState> {
  late final Transaction transaction;

  FutureOr<TransactionEditState> build(Transaction transaction);
}

/// See also [TransactionEditController].
@ProviderFor(TransactionEditController)
const transactionEditControllerProvider = TransactionEditControllerFamily();

/// See also [TransactionEditController].
class TransactionEditControllerFamily
    extends Family<AsyncValue<TransactionEditState>> {
  /// See also [TransactionEditController].
  const TransactionEditControllerFamily();

  /// See also [TransactionEditController].
  TransactionEditControllerProvider call(Transaction transaction) {
    return TransactionEditControllerProvider(transaction);
  }

  @override
  TransactionEditControllerProvider getProviderOverride(
    covariant TransactionEditControllerProvider provider,
  ) {
    return call(provider.transaction);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'transactionEditControllerProvider';
}

/// See also [TransactionEditController].
class TransactionEditControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          TransactionEditController,
          TransactionEditState
        > {
  /// See also [TransactionEditController].
  TransactionEditControllerProvider(Transaction transaction)
    : this._internal(
        () => TransactionEditController()..transaction = transaction,
        from: transactionEditControllerProvider,
        name: r'transactionEditControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$transactionEditControllerHash,
        dependencies: TransactionEditControllerFamily._dependencies,
        allTransitiveDependencies:
            TransactionEditControllerFamily._allTransitiveDependencies,
        transaction: transaction,
      );

  TransactionEditControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.transaction,
  }) : super.internal();

  final Transaction transaction;

  @override
  FutureOr<TransactionEditState> runNotifierBuild(
    covariant TransactionEditController notifier,
  ) {
    return notifier.build(transaction);
  }

  @override
  Override overrideWith(TransactionEditController Function() create) {
    return ProviderOverride(
      origin: this,
      override: TransactionEditControllerProvider._internal(
        () => create()..transaction = transaction,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        transaction: transaction,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    TransactionEditController,
    TransactionEditState
  >
  createElement() {
    return _TransactionEditControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionEditControllerProvider &&
        other.transaction == transaction;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, transaction.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionEditControllerRef
    on AutoDisposeAsyncNotifierProviderRef<TransactionEditState> {
  /// The parameter `transaction` of this provider.
  Transaction get transaction;
}

class _TransactionEditControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          TransactionEditController,
          TransactionEditState
        >
    with TransactionEditControllerRef {
  _TransactionEditControllerProviderElement(super.provider);

  @override
  Transaction get transaction =>
      (origin as TransactionEditControllerProvider).transaction;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
