import 'package:finapp/domain/models/dashboard_models.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'package:finapp/features/dashboard/widgets/account_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountCardStack extends ConsumerStatefulWidget {
  final List<Account> accounts;
  final String? selectedAccountId;
  final PeriodFilter selectedPeriod;
  final ValueChanged<String?> onAccountChanged;
  final ValueChanged<PeriodFilter> onPeriodChanged;

  const AccountCardStack({
    super.key,
    required this.accounts,
    required this.selectedAccountId,
    required this.selectedPeriod,
    required this.onAccountChanged,
    required this.onPeriodChanged,
  });

  @override
  ConsumerState<AccountCardStack> createState() => _AccountCardStackState();
}

class _AccountCardStackState extends ConsumerState<AccountCardStack>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  double _dragOffset = 0.0;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final accounts = widget.accounts;
    final totalCards = 1 + accounts.length; // General + accounts

    return GestureDetector(
      onVerticalDragStart: (_) {
        setState(() {
          _isDragging = true;
        });
      },
      onVerticalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dy;
        });
      },
      onVerticalDragEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond.dy;

        // Swipe up to next card
        if (_dragOffset < -50 || velocity < -500) {
          _changeCard(_currentIndex + 1);
        }
        // Swipe down to previous card
        else if (_dragOffset > 50 || velocity > 500) {
          _changeCard(_currentIndex - 1);
        } else {
          _resetDrag();
        }
      },
      child: SizedBox(
        height: 220,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Only show current card and the next one
            // Build in reverse order so top card is on top
            if (_currentIndex < totalCards - 1)
              _buildStackedCard(_currentIndex + 1, totalCards, accounts),
            _buildStackedCard(_currentIndex, totalCards, accounts),

            // Vertical pagination indicator
            _buildPaginationIndicator(totalCards),
          ],
        ),
      ),
    );
  }

  Widget _buildStackedCard(int index, int totalCards, List<Account> accounts) {
    final isCurrentCard = index == _currentIndex;
    final isNextCard = index == _currentIndex + 1;

    // Calculate position for stacking effect
    double verticalOffset = 0;
    double horizontalPadding = 0;
    double opacity = 1.0;

    if (isNextCard) {
      // Next card visible at TOP
      verticalOffset = -16.0;
      horizontalPadding = 12.0;
      opacity = 0.8;
    } else if (isCurrentCard && _isDragging) {
      // Current card follows drag
      verticalOffset = _dragOffset * 0.5;
    }

    return Positioned(
      top: verticalOffset,
      left: horizontalPadding,
      right: horizontalPadding,
      child: IgnorePointer(
        ignoring: !isCurrentCard,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: opacity,
          child: _buildCard(index, accounts),
        ),
      ),
    );
  }

  Widget _buildCard(int index, List<Account> accounts) {
    if (index == 0) {
      // General card
      return AccountCard(
        account: null,
        balance: ref.watch(dashboardBalanceProvider),
        income: ref.watch(dashboardTotalIncomeProvider),
        expenses: ref.watch(dashboardTotalExpensesProvider),
        selectedPeriod: widget.selectedPeriod,
        onPeriodChanged: widget.onPeriodChanged,
        dailyAverage: ref.watch(dashboardAverageDailySpendingProvider),
        transactionCount: ref.watch(dashboardTransactionCountProvider),
        changePercentage: ref.watch(dashboardSpendingChangePercentageProvider),
      );
    } else {
      // Account-specific card
      final account = accounts[index - 1];
      return AccountCard(
        account: account,
        balance: account.balance,
        income: ref.watch(dashboardTotalIncomeProvider),
        expenses: ref.watch(dashboardTotalExpensesProvider),
        selectedPeriod: widget.selectedPeriod,
        onPeriodChanged: widget.onPeriodChanged,
        dailyAverage: ref.watch(dashboardAverageDailySpendingProvider),
        transactionCount: ref.watch(dashboardTransactionCountProvider),
        changePercentage: ref.watch(dashboardSpendingChangePercentageProvider),
      );
    }
  }

  void _changeCard(int newIndex) {
    // Make navigation circular
    final accounts = widget.accounts;
    final totalCards = 1 + accounts.length;

    // Wrap around
    if (newIndex >= totalCards) {
      newIndex = 0;
    } else if (newIndex < 0) {
      newIndex = totalCards - 1;
    }

    setState(() {
      _currentIndex = newIndex;
      _isDragging = false;
      _dragOffset = 0.0;
    });

    // Update selected account
    if (newIndex == 0) {
      widget.onAccountChanged(null); // General
    } else {
      widget.onAccountChanged(accounts[newIndex - 1].id);
    }
  }

  void _resetDrag() {
    setState(() {
      _isDragging = false;
      _dragOffset = 0.0;
    });
  }

  Widget _buildPaginationIndicator(int totalCards) {
    return Positioned(
      right: 8,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(totalCards, (index) {
              final isActive = index == _currentIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: isActive ? 6 : 4,
                  height: isActive ? 16 : 4,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
