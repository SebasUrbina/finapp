import 'package:finapp/core/widgets/app_pickers.dart';
import 'package:finapp/core/widgets/error_view.dart';
import 'package:finapp/core/widgets/sheet_container.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/transaction_edit/transaction_edit_controller.dart';
import 'package:finapp/features/quick_entry/widgets/account_category_row.dart';
import 'package:finapp/features/quick_entry/widgets/amount_input.dart';
import 'package:finapp/features/quick_entry/widgets/date_selector.dart';
import 'package:finapp/features/quick_entry/widgets/description_input.dart';
import 'package:finapp/features/quick_entry/widgets/save_button.dart';
import 'package:finapp/features/quick_entry/widgets/type_switcher.dart';
import 'package:finapp/features/quick_entry/widgets/recurring_toggle.dart';
import 'package:finapp/features/quick_entry/widgets/recurrence_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionEditSheet extends ConsumerStatefulWidget {
  final Transaction transaction;

  const TransactionEditSheet({super.key, required this.transaction});

  @override
  ConsumerState<TransactionEditSheet> createState() =>
      _TransactionEditSheetState();
}

class _TransactionEditSheetState extends ConsumerState<TransactionEditSheet> {
  bool _isSubmitting = false;
  bool _isDeleting = false;

  Future<void> _handleSubmit(BuildContext context) async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final notifier = ref.read(
      transactionEditControllerProvider(widget.transaction).notifier,
    );
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
              Text('Cambios guardados'),
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

  Future<void> _handleDelete(BuildContext context) async {
    if (_isDeleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Eliminar transacción?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    setState(() => _isDeleting = true);

    final notifier = ref.read(
      transactionEditControllerProvider(widget.transaction).notifier,
    );
    final success = await notifier.delete();

    if (!context.mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.delete_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Transacción eliminada'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Error al eliminar. Intenta de nuevo.'),
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
    final asyncState = ref.watch(
      transactionEditControllerProvider(widget.transaction),
    );
    final notifier = ref.read(
      transactionEditControllerProvider(widget.transaction).notifier,
    );

    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 200),
      child: SheetContainer(
        child: asyncState.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, stack) => ErrorView(
            error: err,
            onRetry: () => ref.invalidate(
              transactionEditControllerProvider(widget.transaction),
            ),
          ),
          data: (state) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and delete button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Editar Transacción',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    _isDeleting
                        ? const SizedBox(
                            width: 40,
                            height: 40,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            onPressed: () => _handleDelete(context),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 20),

                // Amount and Type
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

                // Date
                DateSelector(
                  selectedDate: state.selectedDate,
                  onChanged: notifier.setDate,
                ),
                const SizedBox(height: 16),

                // Description
                DescriptionInput(
                  initialValue: state.description,
                  onChanged: notifier.setDescription,
                ),
                const SizedBox(height: 12),

                // Account, Category, and Recurrence
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

                // Save button
                SaveButton(
                  label: state.isRecurring
                      ? 'Guardar Cambios Recurrentes'
                      : 'Guardar Cambios',
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
}
