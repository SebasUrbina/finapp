import 'package:flutter/material.dart';

class DescriptionInput extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const DescriptionInput({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return TextField(
      decoration: InputDecoration(
        hintText: 'Descripción...',
        hintStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.4)),
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(
          Icons.description_outlined,
          color: colors.primary.withValues(alpha: 0.7),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
