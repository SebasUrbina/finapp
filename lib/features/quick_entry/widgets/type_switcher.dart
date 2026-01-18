import 'package:flutter/material.dart';
import 'package:finapp/domain/models/finance_models.dart';

class TransactionTypeSwitcher extends StatelessWidget {
  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  const TransactionTypeSwitcher({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TypeButton(
            icon: Icons.remove,
            label: '-',
            isSelected: selected == TransactionType.expense,
            onTap: () => onChanged(TransactionType.expense),
            colors: colors,
            isTop: true,
          ),
          Container(height: 1, color: colors.outline.withValues(alpha: 0.1)),
          _TypeButton(
            icon: Icons.add,
            label: '+',
            isSelected: selected == TransactionType.income,
            onTap: () => onChanged(TransactionType.income),
            colors: colors,
            isTop: false,
          ),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colors;
  final bool isTop;

  const _TypeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colors,
    required this.isTop,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isTop ? const Radius.circular(16) : Radius.zero,
        bottom: !isTop ? const Radius.circular(16) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.vertical(
            top: isTop ? const Radius.circular(16) : Radius.zero,
            bottom: !isTop ? const Radius.circular(16) : Radius.zero,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? colors.onPrimary : colors.primary,
          size: 20,
        ),
      ),
    );
  }
}
