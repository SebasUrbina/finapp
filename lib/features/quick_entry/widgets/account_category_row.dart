import 'package:flutter/material.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/theme/app_theme.dart';

class AccountCategoryRow extends StatelessWidget {
  final Account? selectedAccount;
  final Category? selectedCategory;
  final VoidCallback onAccountTap;
  final VoidCallback onCategoryTap;

  const AccountCategoryRow({
    super.key,
    required this.selectedAccount,
    required this.selectedCategory,
    required this.onAccountTap,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onAccountTap,
            borderRadius: BorderRadius.circular(16),
            child: SelectorCard(
              icon:
                  selectedAccount?.icon ??
                  Icons.account_balance_wallet_outlined,
              label: 'Cuenta',
              value: selectedAccount?.name ?? 'Seleccionar',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: onCategoryTap,
            borderRadius: BorderRadius.circular(16),
            child: SelectorCard(
              icon: selectedCategory?.icon ?? Icons.category_outlined,
              label: 'Categoría',
              value: selectedCategory?.name ?? 'Seleccionar',
            ),
          ),
        ),
      ],
    );
  }
}

class SelectorCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const SelectorCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.onSurface.withValues(alpha: 0.5)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
