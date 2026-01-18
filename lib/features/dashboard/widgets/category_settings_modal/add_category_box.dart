import 'package:flutter/material.dart';

class AddCategoryBox extends StatelessWidget {
  final VoidCallback onTap;
  const AddCategoryBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.add_rounded,
                color: Color(0xFF9181F4), // A nice purple for the Add icon
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Añadir',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
