import 'package:flutter/material.dart';
import 'package:finapp/core/constants/category_icons.dart';

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

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    this.tagIds = const [],
  });

  IconData get iconData => CategoryIconMapper.toIcon(icon);
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
}

enum TransactionType { expense, income, transfer }

// Money
class Money {
  final int cents; // CLP no usa decimales, pero esto escala

  const Money(this.cents);

  double get value => cents / 100;

  Money operator +(Money other) => Money(cents + other.cents);
}

// Splits
enum SplitType { equal, percentage, fixedAmount }

class Split {
  final SplitType type;
  final List<SplitParticipant> participants;

  const Split({required this.type, required this.participants});
}

class SplitParticipant {
  final String personId;
  final double value;
  // porcentaje (0–1) o monto según type

  const SplitParticipant({required this.personId, required this.value});
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
}

// Person
class Person {
  final String id;
  final String name;

  const Person({required this.id, required this.name});
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
}
