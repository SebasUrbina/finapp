import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/features/quick_entry/quick_entry_controller.dart';
import 'package:finapp/features/quick_entry/widgets/account_category_row.dart';
import 'package:finapp/features/quick_entry/widgets/amount_input.dart';
import 'package:finapp/features/quick_entry/widgets/date_selector.dart';
import 'package:finapp/features/quick_entry/widgets/description_input.dart';
import 'package:finapp/features/quick_entry/widgets/recurrence_options.dart';
import 'package:finapp/features/quick_entry/widgets/recurring_toggle.dart';
import 'package:finapp/features/quick_entry/widgets/save_button.dart';
import 'package:finapp/features/quick_entry/widgets/type_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuickEntrySheet extends ConsumerWidget {
  const QuickEntrySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providers
    final state = ref.watch(quickEntryControllerProvider);
    final notifier = ref.read(quickEntryControllerProvider.notifier);

    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 200),
      child: _SheetContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TransactionTypeSwitcher(
                selected: state.type,
                onChanged: notifier.setType,
              ),
              const SizedBox(height: 16),
              AmountInput(value: state.amount, onChanged: notifier.setAmount),
              const SizedBox(height: 16),
              DescriptionInput(onChanged: notifier.setDescription),
              const SizedBox(height: 12),
              DateSelector(
                selectedDate: state.selectedDate,
                onChanged: notifier.setDate,
              ),
              const SizedBox(height: 12),
              AccountCategoryRow(
                selectedAccount: state.selectedAccount,
                selectedCategory: state.selectedCategory,
                onAccountTap: () => _showAccountPicker(context, ref),
                onCategoryTap: () => _showCategoryPicker(context, ref),
              ),
              const SizedBox(height: 12),
              RecurringToggle(
                value: state.isRecurring,
                onChanged: notifier.toggleRecurring,
              ),
              if (state.isRecurring) ...[
                const SizedBox(height: 12),
                RecurrenceOptions(
                  frequency: state.frequency,
                  interval: state.interval,
                  dayOfMonth: state.dayOfMonth,
                  onChanged: notifier.setRecurrence,
                ),
              ],
              const SizedBox(height: 24),
              SaveButton(
                isRecurring: state.isRecurring,
                onPressed: state.canSubmit
                    ? () async {
                        await notifier.submit();
                        if (context.mounted) Navigator.pop(context);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAccountPicker(BuildContext context, WidgetRef ref) {
    // Theme
    final colors = Theme.of(context).colorScheme;
    final accounts = ref.watch(accountsProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          // Theme
          final colors = Theme.of(context).colorScheme;
          final accounts = ref.watch(accountsProvider);

          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seleccionar Cuenta',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                SizedBox(height: 16),
                ...accounts.map(
                  (account) => ListTile(
                    leading: Icon(
                      account.icon ?? Icons.account_balance_wallet,
                      color: account.color ?? colors.primary,
                    ),
                    title: Text(
                      account.name,
                      style: TextStyle(color: colors.onSurface),
                    ),
                    subtitle: Text(
                      r'$' + account.balance.value.toStringAsFixed(0),
                      style: TextStyle(color: colors.onSurface),
                    ),
                    onTap: () {
                      ref
                          .read(quickEntryControllerProvider.notifier)
                          .setAccount(account);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCategoryPicker(BuildContext context, WidgetRef ref) {
    // Theme
    final colors = Theme.of(context).colorScheme;

    final notifier = ref.read(quickEntryControllerProvider.notifier);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final categories = ref.watch(categoriesProvider);

          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seleccionar Categoría',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                SizedBox(height: 16),
                Flexible(
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: categories.map((cat) {
                      return InkWell(
                        onTap: () {
                          notifier.setCategory(cat);
                          Navigator.pop(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: colors.surface,
                              child: Icon(cat.icon, color: colors.primary),
                            ),
                            SizedBox(height: 4),
                            Text(
                              cat.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SheetContainer extends StatelessWidget {
  final Widget child;
  const _SheetContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
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
      child: SafeArea(top: false, child: child),
    );
  }
}
