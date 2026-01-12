import 'package:flutter/material.dart';
import 'package:finapp/core/theme/app_theme.dart';

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
        hintStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.5)),
        filled: true,
        fillColor: theme.dividerColor.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.description_outlined, color: colors.onSurface),
      ),
      onChanged: onChanged,
    );
  }
}
