import 'package:flutter/material.dart';
import 'package:finapp/domain/models/finance_models.dart';

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: _MinimalSelector(
            icon:
                selectedAccount?.icon ?? Icons.account_balance_wallet_outlined,
            label: selectedAccount?.name ?? 'Cuenta',
            onTap: onAccountTap,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: _MinimalSelector(
            icon: selectedCategory?.iconData ?? Icons.category_outlined,
            label: selectedCategory?.name ?? 'Categoría',
            onTap: onCategoryTap,
          ),
        ),
      ],
    );
  }
}

class _MinimalSelector extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MinimalSelector({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ActionChip(
      onPressed: onTap,
      avatar: Icon(icon, size: 16, color: colors.primary),
      label: Text(label, overflow: TextOverflow.ellipsis, maxLines: 1),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outline.withValues(alpha: 0.2)),
      ),
      backgroundColor: colors.surfaceContainerLow,
    );
  }
}
