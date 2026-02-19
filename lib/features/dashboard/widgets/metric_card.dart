import 'package:flutter/material.dart';

/// Shared base container for all financial metric cards in the dashboard row.
/// Provides consistent gradient background, border, border-radius, and padding
/// so every card looks visually homogeneous.
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.accent,
    required this.child,
    this.onTap,
  });

  /// The dominant accent color used for the gradient and border.
  final Color accent;

  /// Card content — should be a [Column] with [mainAxisSize.min].
  final Widget child;

  /// Optional tap handler (e.g. to open a bottom sheet).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.15),
            accent.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: child,
    );

    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }
}
