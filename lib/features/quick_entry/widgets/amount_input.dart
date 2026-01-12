import 'package:flutter/material.dart';

class AmountInput extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const AmountInput({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: colors.primary,
      ),
      decoration: InputDecoration(
        hintText: '0',
        hintStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.3)),
        prefixText: r'$',
        prefixStyle: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: colors.primary,
        ),
        border: InputBorder.none,
      ),
      onChanged: (v) {
        final parsed = double.tryParse(v.replaceAll(',', '.'));
        onChanged(parsed ?? 0);
      },
    );
  }
}
