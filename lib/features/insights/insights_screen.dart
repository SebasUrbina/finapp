import 'package:finapp/features/insights/insights_controller.dart';
import 'package:finapp/features/insights/widgets/insights_time_selector.dart';
import 'package:finapp/features/insights/widgets/spending_overview_card.dart';
import 'package:finapp/features/insights/widgets/spending_trend_chart.dart';
import 'package:finapp/features/insights/widgets/category_breakdown_card.dart';
import 'package:finapp/features/insights/widgets/top_expenses_card.dart';
import 'package:finapp/features/insights/widgets/spending_patterns_card.dart';
import 'package:finapp/features/insights/widgets/savings_insights_card.dart';
import 'package:finapp/features/insights/widgets/smart_tips_card.dart';
import 'package:finapp/features/budget/widgets/tag_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final asyncState = ref.watch(insightsControllerProvider);
    final controller = ref.read(insightsControllerProvider.notifier);

    return Scaffold(
      backgroundColor: colors.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [colors.surface, colors.surface]
                : [
                    const Color(0xFFD9C7F7).withValues(alpha: 0.3),
                    colors.surface,
                  ],
          ),
        ),
        child: SafeArea(
          child: asyncState.when(
            skipLoadingOnReload: true, // Prevents flicker
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (state) => CustomScrollView(
              slivers: [
                // Header
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Insights',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Analiza tus finanzas',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.tune_rounded),
                            onPressed: () {
                              // TODO: Open filter options
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Time Selector
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: InsightsTimeSelector(
                      selectedPeriod: state.period,
                      periodLabel: controller.periodLabel,
                      onPeriodChanged: controller.setPeriod,
                      onPreviousTap: controller.previousPeriod,
                      onNextTap: controller.nextPeriod,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // Spending Overview Card
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: SpendingOverviewCard(
                      totalSpending: controller.totalSpending,
                      previousSpending: controller.previousTotalSpending,
                      changePercentage: controller.spendingChangePercentage,
                      averageDaily: controller.averageDailySpending,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Smart Tips
                if (controller.smartTips.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: SmartTipsCard(tips: controller.smartTips),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Spending Trend Chart
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: SpendingTrendChart(
                      data: controller.spendingTrend,
                      maxAmount: controller.trendMaxAmount,
                      averageAmount: controller.trendAverageAmount,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Category Breakdown
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: CategoryBreakdownCard(
                      categories: controller.categoryBreakdown,
                      totalSpending: controller.totalSpending,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Top Expenses Section with Tag Filter
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Categorías',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.filter_list_rounded,
                          size: 20,
                          color: colors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 8)),

                // Tag Filter Bar
                SliverToBoxAdapter(
                  child: TagFilterBar(
                    tags: state.tags,
                    selectedTagId: state.selectedTagId,
                    onTagSelected: controller.setTag,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Top Expenses Card (filtered)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: TopExpensesCard(
                      topCategories: controller.filteredTopExpenses,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Weekly Patterns
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: SpendingPatternsCard(
                      weekdayData: controller.weekdayPatterns,
                      highestDay: controller.highestSpendingDay,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Savings Insights
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: SavingsInsightsCard(
                      savingsRate: controller.savingsRate,
                      totalIncome: controller.totalIncome,
                      totalSpending: controller.totalSpending,
                      netSavings: controller.netSavings,
                      projectedMonthlySavings:
                          controller.projectedMonthlySavings,
                    ),
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
