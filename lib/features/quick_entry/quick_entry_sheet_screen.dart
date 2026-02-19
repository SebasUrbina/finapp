import 'package:finapp/core/widgets/app_pickers.dart';
import 'package:finapp/core/widgets/error_view.dart';
import 'package:finapp/core/widgets/sheet_container.dart';
import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/features/quick_entry/quick_entry_controller.dart';
import 'package:finapp/features/quick_entry/widgets/account_category_row.dart';
import 'package:finapp/features/quick_entry/widgets/amount_input.dart';
import 'package:finapp/features/quick_entry/widgets/date_selector.dart';
import 'package:finapp/features/quick_entry/widgets/description_input.dart';
import 'package:finapp/features/quick_entry/widgets/recurrence_options.dart';
import 'package:finapp/features/quick_entry/widgets/recurring_toggle.dart';
import 'package:finapp/features/quick_entry/widgets/requirement_item.dart';
import 'package:finapp/features/quick_entry/widgets/save_button.dart';
import 'package:finapp/features/quick_entry/widgets/type_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuickEntrySheet extends ConsumerStatefulWidget {
  const QuickEntrySheet({super.key});

  @override
  ConsumerState<QuickEntrySheet> createState() => _QuickEntrySheetState();
}

class _QuickEntrySheetState extends ConsumerState<QuickEntrySheet> {
  bool _isSubmitting = false;

  Future<void> _handleSubmit(BuildContext context) async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final notifier = ref.read(quickEntryControllerProvider.notifier);
    final success = await notifier.submit();

    if (!context.mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Transacción guardada'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Error al guardar. Intenta de nuevo.'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(quickEntryControllerProvider);
    final notifier = ref.read(quickEntryControllerProvider.notifier);

    final accountsAsync = ref.watch(accountsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    final hasAccounts = accountsAsync.valueOrNull?.isNotEmpty ?? false;
    final hasCategories = categoriesAsync.valueOrNull?.isNotEmpty ?? false;
    final isLoadingData = accountsAsync.isLoading || categoriesAsync.isLoading;

    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 200),
      child: SheetContainer(
        child: isLoadingData
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            : (!hasAccounts || !hasCategories)
            ? _buildBlockingUI(context, hasAccounts, hasCategories)
            : asyncState.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, stack) => ErrorView(
                  error: err,
                  onRetry: () => ref.invalidate(quickEntryControllerProvider),
                ),
                data: (state) => SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AmountInput(
                              value: state.amount,
                              onChanged: notifier.setAmount,
                            ),
                          ),
                          const SizedBox(width: 12),
                          TransactionTypeSwitcher(
                            selected: state.type,
                            onChanged: notifier.setType,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      DateSelector(
                        selectedDate: state.selectedDate,
                        onChanged: notifier.setDate,
                      ),
                      const SizedBox(height: 16),
                      DescriptionInput(onChanged: notifier.setDescription),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AccountCategoryRow(
                              selectedAccount: state.selectedAccount,
                              selectedCategory: state.selectedCategory,
                              onAccountTap: () => showAccountPicker(
                                context,
                                ref,
                                onSelected: notifier.setAccount,
                              ),
                              onCategoryTap: () => showCategoryPicker(
                                context,
                                ref,
                                onSelected: notifier.setCategory,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: RecurringToggle(
                              value: state.isRecurring,
                              onChanged: notifier.toggleRecurring,
                            ),
                          ),
                        ],
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
                        label: state.isRecurring
                            ? 'Guardar Recurrente'
                            : 'Guardar Transacción',
                        isLoading: _isSubmitting,
                        onPressed: state.canSubmit
                            ? () => _handleSubmit(context)
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildBlockingUI(
    BuildContext context,
    bool hasAccounts,
    bool hasCategories,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Antes de comenzar...',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Para registrar transacciones necesitas:',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          RequirementItem(
            icon: Icons.account_balance_wallet,
            label: 'Al menos una cuenta',
            isCompleted: hasAccounts,
          ),
          const SizedBox(height: 12),
          RequirementItem(
            icon: Icons.category,
            label: 'Al menos una categoría',
            isCompleted: hasCategories,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver al inicio'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Crea cuentas y categorías desde el menú principal',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
