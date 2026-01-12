import 'package:flutter/material.dart';
import 'package:finapp/core/theme/app_theme.dart';

class SaveButton extends StatelessWidget {
  final bool isRecurring;
  final VoidCallback? onPressed;

  const SaveButton({
    super.key,
    required this.isRecurring,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Theme
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          isRecurring ? 'Guardar gasto recurrente' : 'Guardar transacción',
          style: theme.textTheme.labelLarge,
        ),
      ),
    );
  }
}
