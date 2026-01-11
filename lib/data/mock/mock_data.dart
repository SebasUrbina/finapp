import 'package:flutter/material.dart' hide Split;
import 'package:carenine/core/models/finance_models.dart';

class MockData {
  // Persons
  static const persons = [
    Person(id: 'p1', name: 'Sebastián'),
    Person(id: 'p2', name: 'Maria Paz'),
  ];

  // Tags
  static const tags = [
    Tag(
      id: 'tg_fixed',
      name: 'Fijo',
      type: TagType.expenseNature,
      color: Colors.blue,
    ),
    Tag(
      id: 'tg_variable',
      name: 'Variable',
      type: TagType.expenseNature,
      color: Colors.blue,
    ),
    Tag(
      id: 'tg_needs',
      name: 'Necesidades',
      type: TagType.budgetGroup,
      color: Colors.blue,
    ),
    Tag(
      id: 'tg_wants',
      name: 'Ocio',
      type: TagType.budgetGroup,
      color: Colors.purple,
    ),
    Tag(
      id: 'tg_food',
      name: 'Alimentación',
      type: TagType.lifeArea,
      color: Colors.red,
    ),
    Tag(
      id: 'tg_shared',
      name: 'Compartido',
      type: TagType.ownership,
      color: Colors.indigo,
    ),
  ];

  // Categories
  static const categories = [
    Category(
      id: 'c_rent',
      name: 'Arriendo',
      icon: Icons.home,
      tagIds: ['tg_needs', 'tg_shared', 'tg_fixed'],
    ),
    Category(
      id: 'c_supermarket',
      name: 'Supermercado',
      icon: Icons.shopping_cart,
      tagIds: ['tg_needs', 'tg_food', 'tg_variable'],
    ),
    Category(
      id: 'c_common_expenses',
      name: 'Gastos Comunes',
      icon: Icons.group,
      tagIds: ['tg_shared', 'tg_fixed'],
    ),
  ];

  // Accounts
  static const accounts = [
    Account(
      id: 'a_rut',
      name: 'Cuenta RUT',
      type: AccountType.debit,
      balance: Money(120000),
    ),
    Account(
      id: 'a_fin',
      name: 'Fintual',
      type: AccountType.digitalWallet,
      balance: Money(2400000),
    ),
    Account(
      id: 'a_bci',
      name: 'BCI',
      type: AccountType.debit,
      balance: Money(1200000),
    ),
    Account(
      id: 'a_banco',
      name: 'Banco de Chile',
      type: AccountType.debit,
      balance: Money(1250000),
    ),
  ];

  // Budgets
  static final budgets = [
    Budget(
      id: 'b_food_monthly',
      target: TagBudgetTarget('tg_food'),
      limit: const Money(25000000), // $250.000
      period: BudgetPeriod.monthly,
    ),
    Budget(
      id: 'b_rent_monthly',
      target: CategoryBudgetTarget('c_rent'),
      limit: const Money(25000000),
      period: BudgetPeriod.monthly,
    ),
  ];

  // Transactions
  static List<Transaction> transactions = [
    Transaction(
      id: 't1',
      amount: Money(45000000), // $450.000
      type: TransactionType.expense,
      date: DateTime.now().subtract(const Duration(days: 1)),
      accountId: 'a_rut',
      categoryId: 'c_rent',
      description: 'Arriendo enero',
      split: Split(
        type: SplitType.equal,
        participants: [
          SplitParticipant(personId: 'p1', value: 0.5),
          SplitParticipant(personId: 'p2', value: 0.5),
        ],
      ),
    ),
    Transaction(
      id: 't2',
      amount: Money(12000000),
      type: TransactionType.expense,
      date: DateTime.now().subtract(const Duration(days: 2)),
      accountId: 'a_credit',
      categoryId: 'c_supermarket',
      description: 'Líder',
    ),
    Transaction(
      id: 't3',
      amount: Money(1800000),
      type: TransactionType.expense,
      date: DateTime.now().subtract(const Duration(days: 3)),
      accountId: 'a_cash',
      categoryId: 'c_transport',
      description: 'Bip!',
    ),
    Transaction(
      id: 't4',
      amount: Money(3500000),
      type: TransactionType.expense,
      date: DateTime.now().subtract(const Duration(days: 4)),
      accountId: 'a_credit',
      categoryId: 'c_eating_out',
      description: 'Cena viernes',
      split: Split(
        type: SplitType.fixedAmount,
        participants: [
          SplitParticipant(personId: 'p1', value: 2000000),
          SplitParticipant(personId: 'p2', value: 1500000),
        ],
      ),
    ),
    Transaction(
      id: 't5',
      amount: Money(3500000),
      type: TransactionType.transfer,
      date: DateTime.now().subtract(const Duration(days: 5)),
      accountId: 'a_credit',
      toAccountId: 'a_cash',
      description: 'Cena viernes',
      split: Split(
        type: SplitType.fixedAmount,
        participants: [
          SplitParticipant(personId: 'p1', value: 2000000),
          SplitParticipant(personId: 'p2', value: 1500000),
        ],
      ),
    ),
  ];
}
