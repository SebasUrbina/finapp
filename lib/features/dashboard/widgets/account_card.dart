import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/dashboard/dashboard_state.dart';
import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final Account? account; // null = "General" card
  final Money balance;
  final Money income;
  final Money expenses;
  final PeriodFilter selectedPeriod;
  final ValueChanged<PeriodFilter> onPeriodChanged;

  const AccountCard({
    super.key,
    this.account,
    required this.balance,
    required this.income,
    required this.expenses,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Determine card gradient based on account
    final gradient = _getCardGradient(context);
    final isGeneral = account == null;

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with title and period selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isGeneral ? 'Total Balance' : account!.name,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _buildPeriodSelector(context),
                  ],
                ),
                const SizedBox(height: 6),

                // Balance
                Text(
                  balance.toCurrency(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Income and Expenses row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem('Ingresos', income.toCurrency()),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildStatItem('Gastos', expenses.toCurrency()),
                    ),
                  ],
                ),

                if (!isGeneral) ...[
                  // Account icon/logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          account!.icon ?? Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPeriodButton('Y', PeriodFilter.year),
          const SizedBox(width: 4),
          _buildPeriodButton('W', PeriodFilter.week),
          const SizedBox(width: 4),
          _buildPeriodButton('M', PeriodFilter.month),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String label, PeriodFilter period) {
    final isSelected = selectedPeriod == period;

    return GestureDetector(
      onTap: () => onPeriodChanged(period),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black87 : Colors.white70,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  LinearGradient _getCardGradient(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (account == null) {
      // General card - purple/blue gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF5B4FE5), Color(0xFF3D3A7C)],
      );
    }

    // Account-specific gradient based on account color
    final accountColor = account!.color ?? colors.primary;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        accountColor,
        HSLColor.fromColor(accountColor).withLightness(0.3).toColor(),
      ],
    );
  }
}
