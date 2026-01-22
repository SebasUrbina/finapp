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
  final Money? dailyAverage;
  final int? transactionCount;
  final double? changePercentage;

  const AccountCard({
    super.key,
    this.account,
    required this.balance,
    required this.income,
    required this.expenses,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.dailyAverage,
    this.transactionCount,
    this.changePercentage,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = _getCardGradient(context);
    final isGeneral = account == null;

    return Container(
      height: 220,
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with title and period selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isGeneral ? 'Balance Total' : account!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildPeriodSelector(context),
              ],
            ),
            const SizedBox(height: 8),

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

            const SizedBox(height: 14),

            // Income and Expenses row
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Ingresos',
                    income.toCurrency(),
                    Icons.arrow_downward_rounded,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    'Gastos',
                    expenses.toCurrency(),
                    Icons.arrow_upward_rounded,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Additional metrics pills
            if (dailyAverage != null ||
                transactionCount != null ||
                (changePercentage != null && changePercentage!.abs() > 0.5))
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (dailyAverage != null)
                    _buildMetricPill(
                      Icons.calendar_today,
                      '${dailyAverage!.toCurrency()}/día',
                    ),
                  if (transactionCount != null)
                    _buildMetricPill(
                      Icons.receipt_long_outlined,
                      '$transactionCount trans.',
                    ),
                  if (changePercentage != null && changePercentage!.abs() > 0.5)
                    _buildMetricPill(
                      changePercentage! > 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      '${changePercentage! > 0 ? '+' : ''}${changePercentage!.toStringAsFixed(0)}%',
                      changePercentage! > 0
                          ? const Color(0xFFFFB74D)
                          : const Color(0xFF81C784),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.white70),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildMetricPill(IconData icon, String text, [Color? color]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? Colors.white).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
          _buildPeriodButton('A', PeriodFilter.year),
          const SizedBox(width: 3),
          _buildPeriodButton('S', PeriodFilter.week),
          const SizedBox(width: 3),
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
      // General card - vibrant purple/blue gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
      );
    }

    // Account-specific gradient based on account color
    final accountColor = account!.color ?? colors.primary;
    final hslColor = HSLColor.fromColor(accountColor);

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        accountColor,
        hslColor
            .withLightness((hslColor.lightness * 0.7).clamp(0.2, 0.5))
            .toColor(),
      ],
    );
  }
}
