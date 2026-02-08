import 'package:flutter/material.dart' hide Split;
import 'package:finapp/domain/models/finance_models.dart';

// Note: Los servicios son los que interactuan con el exterior. Por lo tanto, los repositorios son los que interactuan con los servicios.

// Services are stateless Dart classes that interact with APIs, like HTTP servers and platform plugins. Any data that your application needs that isn't created inside the application code itself should be fetched from within service classes.

class LocalDataService {
  // Persons
  static List<Person> persons = [const Person(id: 'p1', name: 'Maria Paz')];

  // Tags
  static List<Tag> tags = [
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
  static List<Category> categories = [
    const Category(
      id: 'c_rent',
      name: 'Arriendo',
      icon: CategoryIcon.home,
      tagIds: ['tg_needs', 'tg_shared', 'tg_fixed'],
      defaultSplit: Split(
        type: SplitType.equal,
        participants: [
          SplitParticipant(personId: 'p1', value: 0.5),
          SplitParticipant(personId: 'p2', value: 0.5),
        ],
      ),
    ),
    const Category(
      id: 'c_supermarket',
      name: 'Supermercado',
      icon: CategoryIcon.shoppingCart,
      tagIds: ['tg_needs', 'tg_food', 'tg_variable'],
      defaultSplit: Split(
        type: SplitType.equal,
        participants: [
          SplitParticipant(personId: 'p1', value: 0.5),
          SplitParticipant(personId: 'p2', value: 0.5),
        ],
      ),
    ),
    const Category(
      id: 'c_common_expenses',
      name: 'Gastos Comunes',
      icon: CategoryIcon.group,
      tagIds: ['tg_shared', 'tg_fixed'],
    ),
    const Category(
      id: 'c_transport',
      name: 'Transporte',
      icon: CategoryIcon.bus,
      tagIds: ['tg_needs', 'tg_variable'],
    ),
    const Category(
      id: 'c_eating_out',
      name: 'Restaurantes',
      icon: CategoryIcon.restaurant,
      tagIds: ['tg_wants', 'tg_food', 'tg_variable'],
    ),
    const Category(
      id: 'c_entertainment',
      name: 'Entretenimiento',
      icon: CategoryIcon.movie,
      tagIds: ['tg_wants', 'tg_variable'],
    ),
    const Category(
      id: 'c_health',
      name: 'Salud',
      icon: CategoryIcon.hospital,
      tagIds: ['tg_needs', 'tg_variable'],
    ),
    const Category(
      id: 'c_utilities',
      name: 'Servicios',
      icon: CategoryIcon.receipt,
      tagIds: ['tg_needs', 'tg_fixed'],
    ),
  ];

  // Accounts
  static List<Account> accounts = [
    Account(
      id: 'a_rut',
      name: 'Cuenta RUT',
      type: AccountType.debit,
      balance: Money(1200000),
      icon: Icons.account_balance,
      color: Colors.blue,
    ),
    Account(
      id: 'a_fin',
      name: 'Fintual',
      type: AccountType.digitalWallet,
      balance: Money(24000000),
      icon: Icons.trending_up,
      color: Colors.green,
    ),
    Account(
      id: 'a_bci',
      name: 'BCI',
      type: AccountType.debit,
      balance: Money(12000000),
      icon: Icons.account_balance,
      color: Colors.orange,
    ),
    Account(
      id: 'a_banco',
      name: 'Banco de Chile',
      type: AccountType.debit,
      balance: Money(12500000),
      icon: Icons.account_balance,
      color: Colors.red,
    ),
    Account(
      id: 'a_credit',
      name: 'Tarjeta Crédito',
      type: AccountType.creditCard,
      balance: Money(-350000), // Negative balance for credit card
      icon: Icons.credit_card,
      color: Colors.purple,
      creditInfo: CreditCardInfo(
        creditLimit: Money(1500000),
        closingDay: 15,
        dueDay: 5,
      ),
    ),
    Account(
      id: 'a_cash',
      name: 'Efectivo',
      type: AccountType.cash,
      balance: Money(45000),
      icon: Icons.payments,
      color: Colors.amber,
    ),
  ];

  // Budgets
  static final budgets = [
    Budget(
      id: 'b_food_monthly',
      target: TagBudgetTarget('tg_food'),
      limit: const Money(250000),
      period: BudgetPeriod.monthly,
    ),
    Budget(
      id: 'b_rent_monthly',
      target: CategoryBudgetTarget('c_rent'),
      limit: const Money(450000),
      period: BudgetPeriod.monthly,
    ),
    Budget(
      id: 'b_transport_monthly',
      target: CategoryBudgetTarget('c_transport'),
      limit: const Money(80000),
      period: BudgetPeriod.monthly,
    ),
    Budget(
      id: 'b_restaurants_monthly',
      target: CategoryBudgetTarget('c_eating_out'),
      limit: const Money(100000),
      period: BudgetPeriod.monthly,
    ),
    Budget(
      id: 'b_entertainment_monthly',
      target: CategoryBudgetTarget('c_entertainment'),
      limit: const Money(120000),
      period: BudgetPeriod.monthly,
    ),
    Budget(
      id: 'b_health_monthly',
      target: CategoryBudgetTarget('c_health'),
      limit: const Money(150000),
      period: BudgetPeriod.monthly,
    ),
    Budget(
      id: 'b_utilities_monthly',
      target: CategoryBudgetTarget('c_utilities'),
      limit: const Money(100000),
      period: BudgetPeriod.monthly,
    ),
    Budget(
      id: 'b_supermarket_monthly',
      target: CategoryBudgetTarget('c_supermarket'),
      limit: const Money(300000),
      period: BudgetPeriod.monthly,
    ),
  ];

  // Transactions
  static List<Transaction> transactions = [
    // Income
    Transaction(
      id: 't_income_1',
      amount: Money(1800000),
      type: TransactionType.income,
      date: DateTime(2026, 2, 1),
      accountId: 'a_banco',
      description: 'Sueldo Febrero',
    ),
    Transaction(
      id: 't_income_2',
      amount: Money(500000),
      type: TransactionType.income,
      date: DateTime(2026, 2, 5),
      accountId: 'a_rut',
      description: 'Freelance',
    ),

    // Expenses - February
    Transaction(
      id: 't1',
      amount: Money(450000),
      type: TransactionType.expense,
      date: DateTime(2026, 2, 2),
      accountId: 'a_rut',
      categoryId: 'c_rent',
      description: 'Arriendo',
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
      amount: Money(120000),
      type: TransactionType.expense,
      date: DateTime(2026, 2, 3),
      accountId: 'a_credit',
      categoryId: 'c_supermarket',
      description: 'Líder',
    ),
    Transaction(
      id: 't3',
      amount: Money(18000),
      type: TransactionType.expense,
      date: DateTime(2026, 2, 4),
      accountId: 'a_cash',
      categoryId: 'c_transport',
      description: 'Bip!',
    ),
    Transaction(
      id: 't4',
      amount: Money(35000),
      type: TransactionType.expense,
      date: DateTime(2026, 2, 5),
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
      amount: Money(85000),
      type: TransactionType.expense,
      date: DateTime(2026, 2, 6),
      accountId: 'a_bci',
      categoryId: 'c_utilities',
      description: 'Luz y agua',
    ),
    Transaction(
      id: 't6',
      amount: Money(65000),
      type: TransactionType.expense,
      date: DateTime(2026, 2, 7),
      accountId: 'a_rut',
      categoryId: 'c_supermarket',
      description: 'Jumbo',
    ),
    Transaction(
      id: 't7',
      amount: Money(25000),
      type: TransactionType.expense,
      date: DateTime(2026, 2, 8),
      accountId: 'a_cash',
      categoryId: 'c_eating_out',
      description: 'Almuerzo',
    ),
    Transaction(
      id: 't8',
      amount: Money(15000),
      type: TransactionType.expense,
      date: DateTime(2026, 2, 9),
      accountId: 'a_credit',
      categoryId: 'c_entertainment',
      description: 'Cine',
    ),
    Transaction(
      id: 't9',
      amount: Money(4500),
      type: TransactionType.expense,
      date: DateTime(2026, 2, 10),
      accountId: 'a_rut',
      categoryId: 'c_transport',
      description: 'Uber',
    ),
    Transaction(
      id: 't10',
      amount: Money(80000),
      type: TransactionType.expense,
      date: DateTime(2026, 2, 10),
      accountId: 'a_bci',
      categoryId: 'c_supermarket',
      description: 'Santa Isabel',
    ),
  ];
}
