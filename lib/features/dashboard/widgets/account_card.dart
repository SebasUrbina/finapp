import 'package:finapp/domain/models/finance_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountCard extends StatelessWidget {
  final Account account;

  const AccountCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final currencyFormat = NumberFormat.currency(
      symbol: r'$',
      decimalDigits: 0,
      locale: 'es_CL',
    );

    final isNegative = account.balance.cents < 0;

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (account.color ?? colors.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              account.icon ?? Icons.account_balance_wallet,
              color: account.color ?? colors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Account name and type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getAccountTypeLabel(account.type),
                  style: TextStyle(color: colors.onSurface, fontSize: 13),
                ),
              ],
            ),
          ),

          // Balance
          Text(
            currencyFormat.format(account.balance.value),
            style: TextStyle(
              color: isNegative ? colors.error : colors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getAccountTypeLabel(AccountType type) {
    switch (type) {
      case AccountType.checking:
        return 'Checking Account';
      case AccountType.debit:
        return 'Debit';
      case AccountType.creditCard:
        return 'Credit Card';
      case AccountType.cash:
        return 'Cash';
      case AccountType.digitalWallet:
        return 'Digital Wallet';
      case AccountType.savings:
        return 'Savings';
      case AccountType.investment:
        return 'Investment';
    }
  }
}
