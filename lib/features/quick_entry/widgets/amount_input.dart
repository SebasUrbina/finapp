import 'package:flutter/material.dart';
import 'package:finapp/core/theme/app_theme.dart';

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
        prefixText: r'$',
        border: InputBorder.none,
      ),
      onChanged: (v) {
        final parsed = double.tryParse(v.replaceAll(',', '.'));
        onChanged(parsed ?? 0);
      },
    );
  }
}
