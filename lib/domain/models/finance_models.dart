import 'package:flutter/material.dart';
import 'package:finapp/core/constants/category_icons.dart';

/// Sentinel value for copyWith nullable clearing
const _sentinel = Object();

/// Safe enum deserialization — supports both legacy int and new string formats.
T _enumByName<T extends Enum>(List<T> values, dynamic raw, T fallback) {
  if (raw is String) {
    return values.firstWhere((e) => e.name == raw, orElse: () => fallback);
  }
  if (raw is int && raw >= 0 && raw < values.length) {
    return values[raw];
  }
  return fallback;
}

enum CategoryIcon {
  home,
  shoppingCart,
  group,
  bus,
  restaurant,
  movie,
  hospital,
  receipt,
  payments,
  trendingUp,
  bank,
  creditCard,
  school,
  fitness,
  flight,
  car,
  pets,
  tools,
  redeem,
  laptop,
}

// Categories
class Category {
  final String id;
  final String name;
  final CategoryIcon icon;

  /// Referencias a tags
  final List<String> tagIds;

  /// Split por defecto para gastos de esta categoría
  final Split? defaultSplit;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    this.tagIds = const [],
    this.defaultSplit,
  });

  CategoryIcon get categoryIcon => icon;

  IconData get iconData => CategoryIconMapper.toIcon(icon);

  Color getColor(BuildContext context) =>
      CategoryIconMapper.toColor(icon, context);

  Category copyWith({
    String? id,
    String? name,
    CategoryIcon? icon,
    List<String>? tagIds,
    Object? defaultSplit = _sentinel,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      tagIds: tagIds ?? this.tagIds,
      defaultSplit: defaultSplit == _sentinel
          ? this.defaultSplit
          : defaultSplit as Split?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon.name,
      'tagIds': tagIds,
      'defaultSplit': defaultSplit?.toMap(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      icon: _enumByName(CategoryIcon.values, map['icon'], CategoryIcon.home),
      tagIds: List<String>.from(map['tagIds'] ?? []),
      defaultSplit: map['defaultSplit'] != null
          ? Split.fromMap(map['defaultSplit'])
          : null,
    );
  }
}

// Note: No usamos subcategorias porque
// 1. Solo permiten un árbol
// 2. Rompen cuando quieres otra vista
// 3. Te fuerzan a duplicar datos

// Tags
class Tag {
  final String id;
  final String name;
  final TagType type;
  final Color color;

  const Tag({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'type': type.name, 'color': color.value};
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: _enumByName(TagType.values, map['type'], TagType.budgetGroup),
      color: Color(map['color'] as int? ?? 0xFF000000),
    );
  }
}

enum TagType {
  budgetGroup, // Necesidades / Ocio
  expenseNature, // Fijo / Variable
  lifeArea, // Vivienda, Transporte, Alimentación
  taxRelevant, // Deducible / No deducible
  ownership, // Personal / Compartido
}

// Transactions
class Transaction {
  final String id;
  final Money amount;
  final TransactionType type;
  final DateTime date;

  // Relaciones
  final String accountId;
  final String? toAccountId;
  final String? categoryId;

  final String? description;

  /// Si es gasto compartido
  final Split? split;

  /// Si viene de una regla recurrente
  final String? recurringRuleId;

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    required this.accountId,
    this.toAccountId,
    this.categoryId,
    this.description,
    this.split,
    this.recurringRuleId,
  });

  Transaction copyWith({
    String? id,
    Money? amount,
    TransactionType? type,
    DateTime? date,
    String? accountId,
    Object? toAccountId = _sentinel,
    Object? categoryId = _sentinel,
    Object? description = _sentinel,
    Object? split = _sentinel,
    Object? recurringRuleId = _sentinel,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId == _sentinel
          ? this.toAccountId
          : toAccountId as String?,
      categoryId: categoryId == _sentinel
          ? this.categoryId
          : categoryId as String?,
      description: description == _sentinel
          ? this.description
          : description as String?,
      split: split == _sentinel ? this.split : split as Split?,
      recurringRuleId: recurringRuleId == _sentinel
          ? this.recurringRuleId
          : recurringRuleId as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount.value,
      'type': type.name,
      'date': date.millisecondsSinceEpoch,
      'accountId': accountId,
      'toAccountId': toAccountId,
      'categoryId': categoryId,
      'description': description,
      'split': split?.toMap(),
      'recurringRuleId': recurringRuleId,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] ?? '',
      amount: Money((map['amount'] as num?)?.toDouble() ?? 0.0),
      type: _enumByName(
        TransactionType.values,
        map['type'],
        TransactionType.expense,
      ),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int? ?? 0),
      accountId: map['accountId'] ?? '',
      toAccountId: map['toAccountId'],
      categoryId: map['categoryId'],
      description: map['description'],
      split: map['split'] != null ? Split.fromMap(map['split']) : null,
      recurringRuleId: map['recurringRuleId'],
    );
  }
}

enum TransactionType { expense, income, transfer }

// Money
class Money {
  final double value;

  const Money(this.value);

  Money operator +(Money other) => Money(value + other.value);
}

// Splits
enum SplitType { equal, percentage, fixedAmount }

class Split {
  final SplitType type;
  final List<SplitParticipant> participants;

  const Split({required this.type, required this.participants});

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'participants': participants.map((x) => x.toMap()).toList(),
    };
  }

  factory Split.fromMap(Map<String, dynamic> map) {
    return Split(
      type: _enumByName(SplitType.values, map['type'], SplitType.equal),
      participants: List<SplitParticipant>.from(
        (map['participants'] as List<dynamic>? ?? []).map<SplitParticipant>(
          (x) => SplitParticipant.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class SplitParticipant {
  final String personId;
  final double value;
  // porcentaje (0–1) o monto según type

  // porcentaje (0–1) o monto según type

  const SplitParticipant({required this.personId, required this.value});

  Map<String, dynamic> toMap() {
    return {'personId': personId, 'value': value};
  }

  factory SplitParticipant.fromMap(Map<String, dynamic> map) {
    return SplitParticipant(
      personId: map['personId'] ?? '',
      value: (map['value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// Budget
sealed class BudgetTarget {}

class CategoryBudgetTarget extends BudgetTarget {
  final String categoryId;
  CategoryBudgetTarget(this.categoryId);
}

class TagBudgetTarget extends BudgetTarget {
  final String tagId;
  TagBudgetTarget(this.tagId);
}

enum BudgetPeriod { monthly, yearly }

class Budget {
  final String id;

  /// Puede ser por categoría o por tag
  final BudgetTarget target;

  final Money limit;
  final BudgetPeriod period;

  const Budget({
    required this.id,
    required this.target,
    required this.limit,
    required this.period,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> targetMap = {};
    if (target is CategoryBudgetTarget) {
      targetMap['type'] = 'category';
      targetMap['categoryId'] = (target as CategoryBudgetTarget).categoryId;
    } else if (target is TagBudgetTarget) {
      targetMap['type'] = 'tag';
      targetMap['tagId'] = (target as TagBudgetTarget).tagId;
    }

    return {
      'id': id,
      'target': targetMap,
      'limit': limit.value,
      'period': period.name,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    BudgetTarget target;
    final targetMap = map['target'] as Map<String, dynamic>? ?? {};
    if (targetMap['type'] == 'tag') {
      target = TagBudgetTarget(targetMap['tagId'] ?? '');
    } else {
      // Default to category
      target = CategoryBudgetTarget(targetMap['categoryId'] ?? '');
    }

    return Budget(
      id: map['id'] ?? '',
      target: target,
      limit: Money((map['limit'] as num?)?.toDouble() ?? 0.0),
      period: _enumByName(
        BudgetPeriod.values,
        map['period'],
        BudgetPeriod.monthly,
      ),
    );
  }
}

// Person
class Person {
  final String id;
  final String name;

  const Person({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(id: map['id'] ?? '', name: map['name'] ?? '');
  }
}

// Account
enum AccountType {
  checking, // Cuenta Corriente
  debit, // Cuenta Vista / RUT
  creditCard, // Tarjeta de Crédito
  cash, // Efectivo
  digitalWallet, // Mach, Tenpo, MP
  savings, // Ahorro
  investment, // APV, fondos, etc.
}

class CreditCardInfo {
  final Money creditLimit;
  final int closingDay; // día de cierre
  final int dueDay; // día de pago

  const CreditCardInfo({
    required this.creditLimit,
    required this.closingDay,
    required this.dueDay,
  });

  Map<String, dynamic> toMap() {
    return {
      'creditLimit': creditLimit.value,
      'closingDay': closingDay,
      'dueDay': dueDay,
    };
  }

  factory CreditCardInfo.fromMap(Map<String, dynamic> map) {
    return CreditCardInfo(
      creditLimit: Money((map['creditLimit'] as num?)?.toDouble() ?? 0.0),
      closingDay: map['closingDay'] as int? ?? 1,
      dueDay: map['dueDay'] as int? ?? 10,
    );
  }
}

class Account {
  final String id;
  final String name;
  final AccountType type;
  final IconData? icon;
  final Color? color;

  /// Balance actual (calculado o persistido)
  final Money balance;

  /// Para tarjetas de crédito
  final CreditCardInfo? creditInfo;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.icon,
    this.color,
    this.creditInfo,
  });

  Account copyWith({
    String? id,
    String? name,
    AccountType? type,
    IconData? icon,
    Color? color,
    Money? balance,
    CreditCardInfo? creditInfo,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      balance: balance ?? this.balance,
      creditInfo: creditInfo ?? this.creditInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'balance': balance.value,
      'icon': icon?.codePoint,
      'iconFontFamily': icon?.fontFamily,
      'color': color?.value,
      'creditInfo': creditInfo?.toMap(),
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: _enumByName(AccountType.values, map['type'], AccountType.checking),
      balance: Money((map['balance'] as num?)?.toDouble() ?? 0.0),
      icon: map['icon'] != null
          ? IconData(
              map['icon'] as int,
              fontFamily: map['iconFontFamily'] as String? ?? 'MaterialIcons',
            )
          : null,
      color: map['color'] != null ? Color(map['color'] as int) : null,
      creditInfo: map['creditInfo'] != null
          ? CreditCardInfo.fromMap(map['creditInfo'])
          : null,
    );
  }
}

// Recurrencia
enum RecurrenceFrequency { daily, weekly, monthly, yearly }

enum RecurringStatus { active, paused, completed }

class RecurringRule {
  final String id;

  /// Datos base de la transacción
  final Money amount;
  final TransactionType type;
  final String accountId;
  final String? toAccountId;
  final String? categoryId;
  final String? description;
  final Split? split;

  /// Reglas de recurrencia
  final RecurrenceFrequency frequency;
  final int interval; // cada X días/semanas/meses
  final DateTime startDate;
  final DateTime? endDate;
  final int? maxOccurrences;

  /// Control
  final RecurringStatus status;
  final DateTime? lastGeneratedAt;
  final int generatedCount;

  const RecurringRule({
    required this.id,
    required this.amount,
    required this.type,
    required this.accountId,
    this.toAccountId,
    this.categoryId,
    this.description,
    this.split,

    required this.frequency,
    this.interval = 1,
    required this.startDate,
    this.endDate,
    this.maxOccurrences,

    this.status = RecurringStatus.active,
    this.lastGeneratedAt,
    this.generatedCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount.value,
      'type': type.name,
      'accountId': accountId,
      'toAccountId': toAccountId,
      'categoryId': categoryId,
      'description': description,
      'split': split?.toMap(),
      'frequency': frequency.name,
      'interval': interval,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'maxOccurrences': maxOccurrences,
      'status': status.name,
      'lastGeneratedAt': lastGeneratedAt?.millisecondsSinceEpoch,
      'generatedCount': generatedCount,
    };
  }

  factory RecurringRule.fromMap(Map<String, dynamic> map) {
    return RecurringRule(
      id: map['id'] ?? '',
      amount: Money((map['amount'] as num?)?.toDouble() ?? 0.0),
      type: _enumByName(
        TransactionType.values,
        map['type'],
        TransactionType.expense,
      ),
      accountId: map['accountId'] ?? '',
      toAccountId: map['toAccountId'],
      categoryId: map['categoryId'],
      description: map['description'],
      split: map['split'] != null ? Split.fromMap(map['split']) : null,
      frequency: _enumByName(
        RecurrenceFrequency.values,
        map['frequency'],
        RecurrenceFrequency.monthly,
      ),
      interval: map['interval'] as int? ?? 1,
      startDate: DateTime.fromMillisecondsSinceEpoch(
        map['startDate'] as int? ?? 0,
      ),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : null,
      maxOccurrences: map['maxOccurrences'] as int?,
      status: _enumByName(
        RecurringStatus.values,
        map['status'],
        RecurringStatus.active,
      ),
      lastGeneratedAt: map['lastGeneratedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastGeneratedAt'] as int)
          : null,
      generatedCount: map['generatedCount'] as int? ?? 0,
    );
  }
}
