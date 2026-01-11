import 'package:carenine/core/models/finance_models.dart';
import 'package:carenine/core/theme/app_theme.dart';
import 'package:carenine/features/quick_entry/quick_entry_provider.dart';
import 'package:carenine/features/quick_entry/quick_entry_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Main quick entry sheet
class QuickEntrySheet extends ConsumerWidget {
  const QuickEntrySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(quickEntryControllerProvider);

    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 200),
      child: _SheetContainer(
        child: SingleChildScrollView(
          // Permite que el sheet se desplace si el contenido es mayor a la altura de la pantalla
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TransactionTypeSwitcher(
                selected: controller.type,
                onChanged: controller.setType,
              ),
              AmountInput(
                value: controller.amount,
                onChanged: controller.setAmount,
              ),
              DescriptionInput(onChanged: controller.setDescription),
              const SizedBox(height: 12),
              AccountCategoryRow(
                selectedAccount: controller.selectedAccount,
                selectedCategory: controller.selectedCategory,
                onAccountTap: () =>
                    _showAccountPicker(context, ref, controller),
                onCategoryTap: () =>
                    _showCategoryPicker(context, ref, controller),
              ),
              const SizedBox(height: 12),
              RecurringToggle(
                value: controller.isRecurring,
                onChanged: controller.toggleRecurring,
              ),
              if (controller.isRecurring) ...[
                const SizedBox(height: 12),
                RecurrenceOptions(
                  frequency: controller.frequency,
                  interval: controller.interval,
                  dayOfMonth: controller.dayOfMonth,
                  onChanged: controller.setRecurrence,
                ),
              ],
              const SizedBox(height: 24),
              SaveButton(
                isRecurring: controller.isRecurring,
                onPressed: controller.canSubmit
                    ? () async {
                        await controller.submit();
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

  void _showAccountPicker(
    BuildContext context,
    WidgetRef ref,
    QuickEntryController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccionar Cuenta',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...controller.accounts.map(
              (account) => ListTile(
                leading: Icon(
                  account.icon ?? Icons.account_balance_wallet,
                  color: account.color ?? AppTheme.primary,
                ),
                title: Text(
                  account.name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  r'$' + account.balance.value.toStringAsFixed(0),
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                onTap: () {
                  controller.setAccount(account);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(
    BuildContext context,
    WidgetRef ref,
    QuickEntryController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccionar Categoría',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: controller.categories.map((cat) {
                  return InkWell(
                    onTap: () {
                      controller.setCategory(cat);
                      Navigator.pop(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.background,
                          child: Icon(cat.icon, color: AppTheme.primary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cat.name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
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
      ),
    );
  }
}
// Widgetprivados

class DescriptionInput extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const DescriptionInput({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Descripción...',
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: AppTheme.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(
          Icons.description_outlined,
          color: AppTheme.textSecondary,
        ),
      ),
      onChanged: onChanged,
    );
  }
}

class AmountInput extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const AmountInput({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: AppTheme.primary,
      ),
      decoration: const InputDecoration(
        hintText: '0',
        prefixText: r'$',
        border: InputBorder.none,
      ),
      onChanged: (v) {
        final parsed = double.tryParse(v.replaceAll(',', '.'));
        onChanged(parsed ?? 0);
      },
    );
  }
}

// Selector widgets

class AccountCategoryRow extends StatelessWidget {
  final Account? selectedAccount;
  final Category? selectedCategory;
  final VoidCallback onAccountTap;
  final VoidCallback onCategoryTap;

  const AccountCategoryRow({
    super.key,
    required this.selectedAccount,
    required this.selectedCategory,
    required this.onAccountTap,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onAccountTap,
            borderRadius: BorderRadius.circular(16),
            child: _SelectorCard(
              icon:
                  selectedAccount?.icon ??
                  Icons.account_balance_wallet_outlined,
              label: 'Cuenta',
              value: selectedAccount?.name ?? 'Seleccionar',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: onCategoryTap,
            borderRadius: BorderRadius.circular(16),
            child: _SelectorCard(
              icon: selectedCategory?.icon ?? Icons.category_outlined,
              label: 'Categoría',
              value: selectedCategory?.name ?? 'Seleccionar',
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectorCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SelectorCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecurringToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RecurringToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Gasto recurrente'),
      subtitle: const Text('Se repetirá automáticamente'),
      value: value,
      onChanged: onChanged,
    );
  }
}

class SaveButton extends StatelessWidget {
  final bool isRecurring;
  final VoidCallback? onPressed;

  const SaveButton({
    super.key,
    required this.isRecurring,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          isRecurring ? 'Guardar gasto recurrente' : 'Guardar transacción',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class IntervalSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const IntervalSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Cada'),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
        ),
        Text('$value'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class RecurrenceFrequencySelector extends StatelessWidget {
  final RecurrenceFrequency selected;
  final ValueChanged<RecurrenceFrequency> onChanged;

  const RecurrenceFrequencySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: RecurrenceFrequency.values.map((f) {
        return ChoiceChip(
          label: Text(f.name),
          selected: selected == f,
          onSelected: (_) => onChanged(f),
        );
      }).toList(),
    );
  }
}

class RecurrenceOptions extends StatelessWidget {
  final RecurrenceFrequency frequency;
  final int interval;
  final int dayOfMonth;
  final void Function(RecurrenceFrequency, int, int) onChanged;

  const RecurrenceOptions({
    super.key,
    required this.frequency,
    required this.interval,
    required this.dayOfMonth,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RecurrenceFrequencySelector(
          selected: frequency,
          onChanged: (f) => onChanged(f, interval, dayOfMonth),
        ),
        IntervalSelector(
          value: interval,
          onChanged: (i) => onChanged(frequency, i, dayOfMonth),
        ),
        if (frequency == RecurrenceFrequency.monthly)
          DayOfMonthSelector(
            value: dayOfMonth,
            onChanged: (d) => onChanged(frequency, interval, d),
          ),
      ],
    );
  }
}

class DayOfMonthSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const DayOfMonthSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Día del mes'),
        Slider(
          min: 1,
          max: 30,
          divisions: 29,
          value: value.toDouble(),
          label: value.toString(),
          onChanged: (v) => onChanged(v.toInt()),
        ),
      ],
    );
  }
}

class _SheetContainer extends StatelessWidget {
  final Widget child;

  const _SheetContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

// convertir bloques en widgets reutilizables
class TransactionTypeSwitcher extends StatelessWidget {
  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  const TransactionTypeSwitcher({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SegmentedButton<TransactionType>(
            segments: const [
              ButtonSegment<TransactionType>(
                value: TransactionType.expense,
                label: Text('Gasto'),
              ),
              ButtonSegment<TransactionType>(
                value: TransactionType.income,
                label: Text('Ingreso'),
              ),
              // TODO: Implement UI for transfer
              // ButtonSegment<TransactionType>(
              //   value: TransactionType.transfer,
              //   label: Text('Transfer.'),
              // ),
            ],
            selected: {selected},
            onSelectionChanged: (v) => onChanged(v.first),
          ),
        ),
      ],
    );
  }
}

// Splitselectort
class SplitSelector extends StatelessWidget {
  final double selected;
  final ValueChanged<double> onChanged;

  const SplitSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = {
      'Individual': 1.0,
      '50/50 con Sofi': 0.5,
      '70/30 con Sofi': 0.7,
      'Personalizado': 0.0,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.entries.map((e) {
          final isSelected = selected == e.value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(e.key),
              selected: isSelected,
              onSelected: (_) => onChanged(e.value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
