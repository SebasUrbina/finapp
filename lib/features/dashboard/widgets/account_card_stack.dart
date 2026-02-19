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
  // Only UI-local state: drag gesture.
  double _dragOffset = 0.0;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final accounts = widget.accounts;
    final totalCards = 1 + accounts.length;

    // Watch the provider so the widget rebuilds when selection changes.
    final selectedId = ref.watch(dashboardSelectedAccountProvider);

    // Automatically reset selection when the selected account was deleted.
    ref.listen<String?>(dashboardSelectedAccountProvider, (_, next) {
      if (next != null && !accounts.any((a) => a.id == next)) {
        ref
            .read(dashboardSelectedAccountProvider.notifier)
            .setSelectedAccount(null);
      }
    });

    // Derive index: always valid, no clamping hacks needed.
    final currentIndex = selectedId == null
        ? 0
        : () {
            final idx = accounts.indexWhere((a) => a.id == selectedId);
            return idx >= 0 ? idx + 1 : 0;
          }();

    return GestureDetector(
      onVerticalDragStart: (_) {
        setState(() => _isDragging = true);
      },
      onVerticalDragUpdate: (details) {
        setState(() => _dragOffset += details.delta.dy);
      },
      onVerticalDragEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond.dy;

        if (_dragOffset < -50 || velocity < -500) {
          _changeCard(currentIndex + 1, accounts);
        } else if (_dragOffset > 50 || velocity > 500) {
          _changeCard(currentIndex - 1, accounts);
        } else {
          _resetDrag();
        }
      },
      child: SizedBox(
        height: 220,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (currentIndex < totalCards - 1)
              _buildStackedCard(currentIndex + 1, currentIndex, accounts),
            _buildStackedCard(currentIndex, currentIndex, accounts),
            _buildPaginationIndicator(totalCards, currentIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildStackedCard(
    int index,
    int currentIndex,
    List<Account> accounts,
  ) {
    final isCurrentCard = index == currentIndex;
    final isNextCard = index == currentIndex + 1;

    double verticalOffset = 0;
    double horizontalPadding = 0;
    double opacity = 1.0;

    if (isNextCard) {
      verticalOffset = -16.0;
      horizontalPadding = 12.0;
      opacity = 0.8;
    } else if (isCurrentCard && _isDragging) {
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

  void _changeCard(int newIndex, List<Account> accounts) {
    final totalCards = 1 + accounts.length;

    // Circular wrap-around
    if (newIndex >= totalCards) newIndex = 0;
    if (newIndex < 0) newIndex = totalCards - 1;

    // Reset drag state
    setState(() {
      _isDragging = false;
      _dragOffset = 0.0;
    });

    // Update the provider — single source of truth
    final newAccountId = newIndex == 0 ? null : accounts[newIndex - 1].id;
    ref
        .read(dashboardSelectedAccountProvider.notifier)
        .setSelectedAccount(newAccountId);
    widget.onAccountChanged(newAccountId);
  }

  void _resetDrag() {
    setState(() {
      _isDragging = false;
      _dragOffset = 0.0;
    });
  }

  Widget _buildPaginationIndicator(int totalCards, int currentIndex) {
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
              final isActive = index == currentIndex;
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
