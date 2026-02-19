import 'package:finapp/core/constants/category_icons.dart';
import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'package:finapp/features/dashboard/widgets/metric_card.dart';
import 'package:finapp/domain/models/dashboard_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopCategoryCard extends ConsumerWidget {
  const TopCategoryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final period = ref.watch(dashboardPeriodProvider);
    final top = ref.watch(dashboardTopCategoryByTagProvider(null));
    final totalExpensesAmount = ref.watch(
      dashboardTotalExpensesProvider.select((m) => m.value),
    );
    const accent = Color(0xFF9C27B0);

    final pct = (top != null && totalExpensesAmount > 0)
        ? (top.value.value / totalExpensesAmount).clamp(0.0, 1.0)
        : 0.0;

    final periodLabel = switch (period) {
      PeriodFilter.year => 'este año',
      PeriodFilter.month => 'este mes',
      PeriodFilter.week => 'esta sem.',
    };

    return MetricCard(
      accent: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ───────────────────────────────────────────────────
          Row(
            children: [
              Icon(
                Icons.bar_chart_rounded,
                size: 11,
                color: accent.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Mayor gasto · $periodLabel',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (top != null) ...[
            // ── Icon + name row ────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CategoryIconMapper.toIcon(top.key.icon),
                    color: accent,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    top.key.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Amount ────────────────────────────────────────────────
            Text(
              top.value.toCurrency(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
            const SizedBox(height: 8),

            // ── Progress bar ──────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 4,
                backgroundColor: accent.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
            const SizedBox(height: 5),

            // ── Pct pill ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${(pct * 100).toStringAsFixed(0)}% del total',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: accent,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Sin gastos\nregistrados',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
