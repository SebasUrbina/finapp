import 'package:flutter/material.dart' hide Split;
import 'package:finapp/domain/models/finance_models.dart';

// Note: Los servicios son los que interactuan con el exterior. Por lo tanto, los repositorios son los que interactuan con los servicios.

// Services are stateless Dart classes that interact with APIs, like HTTP servers and platform plugins. Any data that your application needs that isn't created inside the application code itself should be fetched from within service classes.

class LocalDataService {
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
    Category(
      id: 'c_transport',
      name: 'Transporte',
      icon: Icons.directions_bus,
      tagIds: ['tg_needs', 'tg_variable'],
    ),
    Category(
      id: 'c_eating_out',
      name: 'Restaurantes',
      icon: Icons.restaurant,
      tagIds: ['tg_wants', 'tg_food', 'tg_variable'],
    ),
    Category(
      id: 'c_entertainment',
      name: 'Entretenimiento',
      icon: Icons.movie,
      tagIds: ['tg_wants', 'tg_variable'],
    ),
    Category(
      id: 'c_health',
      name: 'Salud',
      icon: Icons.local_hospital,
      tagIds: ['tg_needs', 'tg_variable'],
    ),
    Category(
      id: 'c_utilities',
      name: 'Servicios',
      icon: Icons.receipt_long,
      tagIds: ['tg_needs', 'tg_fixed'],
    ),
  ];

  // Accounts
  static const accounts = [
    Account(
      id: 'a_rut',
      name: 'Cuenta RUT',
      type: AccountType.debit,
      balance: Money(120000000),
      icon: Icons.account_balance,
      color: Colors.blue,
    ),
    Account(
      id: 'a_fin',
      name: 'Fintual',
      type: AccountType.digitalWallet,
      balance: Money(2400000000),
      icon: Icons.trending_up,
      color: Colors.green,
    ),
    Account(
      id: 'a_bci',
      name: 'BCI',
      type: AccountType.debit,
      balance: Money(1200000000),
      icon: Icons.account_balance,
      color: Colors.orange,
    ),
    Account(
      id: 'a_banco',
      name: 'Banco de Chile',
      type: AccountType.debit,
      balance: Money(1250000000),
      icon: Icons.account_balance,
      color: Colors.red,
    ),
    Account(
      id: 'a_credit',
      name: 'Tarjeta Crédito',
      type: AccountType.creditCard,
      balance: Money(-350000000), // Negative balance for credit card
      icon: Icons.credit_card,
      color: Colors.purple,
      creditInfo: CreditCardInfo(
        creditLimit: Money(150000000),
        closingDay: 15,
        dueDay: 5,
      ),
    ),
    Account(
      id: 'a_cash',
      name: 'Efectivo',
      type: AccountType.cash,
      balance: Money(45000000),
      icon: Icons.payments,
      color: Colors.amber,
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
    // Income
    Transaction(
      id: 't_income_1',
      amount: Money(180000000), // $1,800,000
      type: TransactionType.income,
      date: DateTime(2026, 1, 1),
      accountId: 'a_banco',
      description: 'Sueldo Enero',
    ),
    Transaction(
      id: 't_income_2',
      amount: Money(50000000), // $500,000
      type: TransactionType.income,
      date: DateTime(2026, 1, 5),
      accountId: 'a_rut',
      description: 'Freelance',
    ),

    // Expenses - January
    Transaction(
      id: 't1',
      amount: Money(45000000), // $450,000
      type: TransactionType.expense,
      date: DateTime(2026, 1, 2),
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
      amount: Money(12000000), // $120,000
      type: TransactionType.expense,
      date: DateTime(2026, 1, 3),
      accountId: 'a_credit',
      categoryId: 'c_supermarket',
      description: 'Líder',
    ),
    Transaction(
      id: 't3',
      amount: Money(1800000), // $18,000
      type: TransactionType.expense,
      date: DateTime(2026, 1, 4),
      accountId: 'a_cash',
      categoryId: 'c_transport',
      description: 'Bip!',
    ),
    Transaction(
      id: 't4',
      amount: Money(3500000), // $35,000
      type: TransactionType.expense,
      date: DateTime(2026, 1, 5),
      accountId: 'a_credit',
      categoryId: 'c_eating_out',
      description: 'Cena viernes',
      split: Split(
        type: SplitType.equal,
        participants: [
          SplitParticipant(personId: 'p1', value: 0.5),
          SplitParticipant(personId: 'p2', value: 0.5),
        ],
      ),
    ),
    Transaction(
      id: 't5',
      amount: Money(8500000), // $85,000
      type: TransactionType.expense,
      date: DateTime(2026, 1, 6),
      accountId: 'a_bci',
      categoryId: 'c_utilities',
      description: 'Luz y agua',
    ),
    Transaction(
      id: 't6',
      amount: Money(6500000), // $65,000
      type: TransactionType.expense,
      date: DateTime(2026, 1, 7),
      accountId: 'a_rut',
      categoryId: 'c_supermarket',
      description: 'Jumbo',
    ),
    Transaction(
      id: 't7',
      amount: Money(2500000), // $25,000
      type: TransactionType.expense,
      date: DateTime(2026, 1, 8),
      accountId: 'a_cash',
      categoryId: 'c_eating_out',
      description: 'Almuerzo',
    ),
    Transaction(
      id: 't8',
      amount: Money(15000000), // $150,000
      type: TransactionType.expense,
      date: DateTime(2026, 1, 9),
      accountId: 'a_credit',
      categoryId: 'c_entertainment',
      description: 'Cine',
    ),
    Transaction(
      id: 't9',
      amount: Money(4500000), // $45,000
      type: TransactionType.expense,
      date: DateTime(2026, 1, 10),
      accountId: 'a_rut',
      categoryId: 'c_transport',
      description: 'Uber',
    ),
    Transaction(
      id: 't10',
      amount: Money(8000000), // $80,000
      type: TransactionType.expense,
      date: DateTime(2026, 1, 10),
      accountId: 'a_bci',
      categoryId: 'c_supermarket',
      description: 'Santa Isabel',
    ),
  ];
}
