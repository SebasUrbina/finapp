import 'package:flutter/material.dart';

class RecurringToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RecurringToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: FilterChip(
        label: const Text(
          'Recurrente',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        selected: value,
        onSelected: onChanged,
        selectedColor: colors.primaryContainer,
        checkmarkColor: colors.primary,
        labelStyle: TextStyle(
          fontSize: 12,
          color: value ? colors.primary : colors.onSurface,
          fontWeight: value ? FontWeight.bold : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: value
                ? colors.primary
                : colors.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }
}
