import 'package:flutter/material.dart';

/// Widget para mostrar un item de requerimiento
class RequirementItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isCompleted;

  const RequirementItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
            : theme.colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isCompleted
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            isCompleted ? Icons.check_circle : Icons.cancel,
            color: isCompleted
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
          ),
        ],
      ),
    );
  }
}
