import 'package:flutter/material.dart';

/// A styled container for modal bottom sheets.
///
/// Provides consistent styling (rounded corners, shadow, drag handle)
/// across all bottom sheets in the app.
class SheetContainer extends StatelessWidget {
  final Widget child;

  /// Whether to show the drag handle at the top of the sheet.
  final bool showDragHandle;

  const SheetContainer({
    super.key,
    required this.child,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDragHandle)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }
}
