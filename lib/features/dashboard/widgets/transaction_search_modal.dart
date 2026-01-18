import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/dashboard/transaction_search/transaction_search_provider.dart';
import 'package:finapp/features/dashboard/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionSearchModal extends ConsumerStatefulWidget {
  final List<Transaction> transactions;
  final List<Category> categories;
  final List<Account> accounts;

  const TransactionSearchModal({
    super.key,
    required this.transactions,
    required this.categories,
    required this.accounts,
  });

  @override
  ConsumerState<TransactionSearchModal> createState() =>
      _TransactionSearchModalState();
}

class _TransactionSearchModalState
    extends ConsumerState<TransactionSearchModal> {
  final TextEditingController _searchController = TextEditingController();
  late TransactionSearchParams params;

  @override
  void initState() {
    super.initState();
    params = TransactionSearchParams(
      transactions: widget.transactions,
      categories: widget.categories,
      accounts: widget.accounts,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Watch state (reactive)
    final state = ref.watch(transactionSearchProvider(params));
    final groupedTransactions = ref.watch(groupedTransactionsProvider(params));

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              border: Border(
                bottom: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colors.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Title and close button
                Row(
                  children: [
                    Text(
                      'Buscar transacciones',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: colors.onSurfaceVariant),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Search field
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    // Use read for actions (not reactive)
                    ref
                        .read(transactionSearchProvider(params).notifier)
                        .setSearchQuery(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar por descripción, categoría o monto...',
                    hintStyle: TextStyle(
                      color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: colors.onSurfaceVariant,
                    ),
                    suffixIcon: state.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: colors.onSurfaceVariant,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              // Use read for actions
                              ref
                                  .read(
                                    transactionSearchProvider(params).notifier,
                                  )
                                  .clearSearch();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: colors.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: state.filteredTransactions.isEmpty
                ? _buildEmptyState(context, state.searchQuery)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: groupedTransactions.length,
                    itemBuilder: (context, index) {
                      final monthKey = groupedTransactions.keys.elementAt(
                        index,
                      );
                      final transactions = groupedTransactions[monthKey]!;

                      return _buildMonthGroup(context, monthKey, transactions);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGroup(
    BuildContext context,
    String monthKey,
    List<Transaction> transactions,
  ) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    // Calculate total for the month
    final totalExpenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold<Money>(const Money(0), (sum, t) => sum + t.amount);

    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold<Money>(const Money(0), (sum, t) => sum + t.amount);

    final currencyFormat = NumberFormat.currency(
      symbol: r'$',
      decimalDigits: 0,
      locale: 'es_CL',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            children: [
              Text(
                monthKey.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (totalExpenses.cents > 0)
                Text(
                  currencyFormat.format(totalExpenses.value),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (totalIncome.cents > 0) ...[
                if (totalExpenses.cents > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '•',
                      style: TextStyle(
                        color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                Text(
                  currencyFormat.format(totalIncome.value),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Transactions list
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: transactions.asMap().entries.map((entry) {
              final index = entry.key;
              final transaction = entry.value;

              // Watch providers for category and account
              final category = ref.watch(
                categoryByIdProvider((
                  params: params,
                  categoryId: transaction.categoryId,
                )),
              );
              final account = ref.watch(
                accountByIdProvider((
                  params: params,
                  accountId: transaction.accountId,
                )),
              );

              final isLast = index == transactions.length - 1;

              return Column(
                children: [
                  TransactionListItem(
                    transaction: transaction,
                    category: category,
                    account: account,
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colors.outlineVariant,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String searchQuery) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: colors.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isEmpty
                ? 'No hay transacciones'
                : 'No se encontraron resultados',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Intenta con otros términos de búsqueda',
              style: TextStyle(
                color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
