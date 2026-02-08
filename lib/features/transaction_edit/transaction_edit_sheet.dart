import 'package:finapp/data/providers/finance_providers.dart';
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

class TransactionEditSheet extends ConsumerWidget {
  final Transaction transaction;

  const TransactionEditSheet({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usar el provider family pasando la transacción
    final asyncState = ref.watch(
      transactionEditControllerProvider(transaction),
    );
    final notifier = ref.read(
      transactionEditControllerProvider(transaction).notifier,
    );

    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 200),
      child: _SheetContainer(
        child: asyncState.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (state) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y botón de eliminar
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
                    IconButton(
                      onPressed: () {
                        _showDeleteConfirmation(context, notifier);
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Monto y Tipo
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

                // Fecha
                DateSelector(
                  selectedDate: state.selectedDate,
                  onChanged: notifier.setDate,
                ),
                const SizedBox(height: 16),

                // Descripción
                DescriptionInput(
                  initialValue: state.description,
                  onChanged: notifier.setDescription,
                ),
                const SizedBox(height: 12),

                // Cuenta, Categoría y Recurrencia
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AccountCategoryRow(
                        selectedAccount: state.selectedAccount,
                        selectedCategory: state.selectedCategory,
                        onAccountTap: () =>
                            _showAccountPicker(context, ref, notifier),
                        onCategoryTap: () =>
                            _showCategoryPicker(context, ref, notifier),
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

                // Botón Guardar
                SaveButton(
                  label: state.isRecurring
                      ? 'Guardar Cambios Recurrentes'
                      : 'Guardar Cambios',
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
      ),
    );
  }

  void _showAccountPicker(
    BuildContext context,
    WidgetRef ref,
    TransactionEditController notifier,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final colors = Theme.of(context).colorScheme;
          final accountsAsync = ref.watch(accountsProvider);

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
                const SizedBox(height: 16),
                Flexible(
                  child: accountsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Text('Error loading accounts: $err'),
                    data: (accounts) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        final account = accounts[index];
                        return ListTile(
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
                            notifier.setAccount(account);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCategoryPicker(
    BuildContext context,
    WidgetRef ref,
    TransactionEditController notifier,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final colors = Theme.of(context).colorScheme;
          final categoriesAsync = ref.watch(categoriesProvider);

          return Container(
            padding: const EdgeInsets.all(24),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
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
                const SizedBox(height: 16),
                Flexible(
                  child: categoriesAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) =>
                        Text('Error loading categories: $err'),
                    data: (categories) => GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return InkWell(
                          onTap: () {
                            notifier.setCategory(cat);
                            Navigator.pop(context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: colors.surfaceContainerLow,
                                child: Icon(
                                  cat.iconData,
                                  color: colors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cat.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.onSurface,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    TransactionEditController notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar transacción?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await notifier.delete();
              if (context.mounted) Navigator.pop(context); // Close sheet
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
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
