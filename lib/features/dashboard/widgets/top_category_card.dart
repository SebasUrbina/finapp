import 'package:finapp/core/constants/category_icons.dart';
import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'package:finapp/features/dashboard/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopCategoryCard extends ConsumerStatefulWidget {
  const TopCategoryCard({super.key});

  @override
  ConsumerState<TopCategoryCard> createState() => _TopCategoryCardState();
}

class _TopCategoryCardState extends ConsumerState<TopCategoryCard> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final state = ref.watch(dashboardControllerProvider);

    // List of tags including "null" for "Todas"
    final List<String?> tagIds = [null, ...state.tags.map((t) => t.id)];
    final totalPages = tagIds.length;

    return Container(
      height: 170, // Fixed height for consistency
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF9C27B0).withValues(alpha: 0.15),
            const Color(0xFFBA68C8).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF9C27B0).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: totalPages,
              itemBuilder: (context, index) {
                final tagId = tagIds[index];
                final tagName = index == 0
                    ? 'Todas'
                    : state.tags[index - 1].name;
                final topCategoryEntry = ref.watch(
                  dashboardTopCategoryByTagProvider(tagId),
                );
                final totalExpenses = ref
                    .watch(dashboardTotalExpensesProvider)
                    .value;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Top',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF9C27B0,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tagName,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: const Color(
                                  0xFF9C27B0,
                                ).withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (topCategoryEntry != null) ...[
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF9C27B0,
                                ).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CategoryIconMapper.toIcon(
                                  topCategoryEntry.key.icon,
                                ),
                                color: const Color(0xFF9C27B0),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                topCategoryEntry.key.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(
                                    0xFF9C27B0,
                                  ).withValues(alpha: 0.9),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          topCategoryEntry.value.toCurrency(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (totalExpenses > 0)
                          Text(
                            '${((topCategoryEntry.value.value / totalExpenses) * 100).toStringAsFixed(0)}% del total',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                      ] else ...[
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Sin gastos',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          // Page Indicator (Dots)
          if (totalPages > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalPages, (index) {
                  final isActive = _currentPage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 4,
                    width: isActive ? 12 : 4,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF9C27B0)
                          : const Color(0xFF9C27B0).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
