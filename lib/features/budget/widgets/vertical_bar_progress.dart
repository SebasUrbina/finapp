import 'package:flutter/material.dart';

/// Vertical bar progress indicator with animated bars
class VerticalBarProgress extends StatelessWidget {
  final double percentage;
  final int barCount;
  final double height;
  final Color? color;

  const VerticalBarProgress({
    super.key,
    required this.percentage,
    this.barCount = 30,
    this.height = 60,
    this.color,
  });

  Color _getColorForPercentage(BuildContext context) {
    if (color != null) return color!;

    final colors = Theme.of(context).colorScheme;

    if (percentage < 50) {
      return colors.tertiary; // Green
    } else if (percentage < 75) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return colors.error; // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    final barColor = _getColorForPercentage(context);
    final filledBars = (barCount * (percentage / 100)).round();

    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(barCount, (index) {
          final isFilled = index < filledBars;
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: 4,
              height: isFilled ? height : height * 0.3,
              decoration: BoxDecoration(
                color: isFilled ? barColor : barColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
