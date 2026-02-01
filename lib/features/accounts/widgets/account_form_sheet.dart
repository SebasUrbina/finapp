import 'package:finapp/core/widgets/app_dialogs.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AccountFormSheet extends StatefulWidget {
  final Account? account;
  final Function(Account) onSave;
  final Function(String)? onDelete;

  const AccountFormSheet({
    super.key,
    this.account,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<AccountFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late AccountType _selectedType;
  late Color _selectedColor;
  late IconData _selectedIcon;

  final List<IconData> _availableIcons = [
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.credit_card,
    Icons.payments,
    Icons.trending_up,
    Icons.savings,
    Icons.wallet,
    Icons.attach_money,
    Icons.euro,
    Icons.currency_bitcoin,
    Icons.smartphone,
    Icons.home,
    Icons.car_rental,
    Icons.shopping_bag,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _balanceController = TextEditingController(
      text: widget.account?.balance.value.toFormatted() ?? '0',
    );
    _selectedType = widget.account?.type ?? AccountType.debit;
    _selectedColor = widget.account?.color ?? Colors.blue;
    _selectedIcon = widget.account?.icon ?? Icons.account_balance;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final balance = CurrencyFormatter.parse(_balanceController.text);
      final account = Account(
        id: widget.account?.id ?? 'acc_${Random().nextInt(10000)}',
        name: _nameController.text,
        type: _selectedType,
        balance: Money(balance),
        color: _selectedColor,
        icon: _selectedIcon,
        creditInfo: widget.account?.creditInfo,
      );

      widget.onSave(account);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.account == null ? 'Nueva Cuenta' : 'Editar Cuenta',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.account != null && widget.onDelete != null)
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: colors.error),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AppDeleteDialog(
                          title: 'Eliminar Cuenta',
                          content: Text(
                            '¿Estás seguro de que deseas eliminar la cuenta "${widget.account?.name}"? Esta acción borrará la cuenta y todos sus movimientos asociados. No se puede deshacer.',
                          ),
                          onConfirm: () {
                            widget.onDelete!(widget.account!.id);
                            if (context.mounted) {
                              Navigator.pop(context); // Close dialog
                              Navigator.pop(context); // Close form sheet
                            }
                          },
                        ),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: colors.error.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Personaliza los detalles de tu cuenta bancaria o efectivo',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),

              // Preview Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _selectedColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(_selectedIcon, color: _selectedColor, size: 40),
                ),
              ),
              const SizedBox(height: 32),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la cuenta',
                  prefixIcon: const Icon(Icons.label_outline),
                  filled: true,
                  fillColor: colors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              // Balance Field
              TextFormField(
                controller: _balanceController,
                decoration: InputDecoration(
                  labelText: 'Saldo Actual',
                  prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                  filled: true,
                  fillColor: colors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 24),

              // Account Type
              Text(
                'Tipo de Cuenta',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<AccountType>(
                    initialValue: _selectedType,
                    dropdownColor: colors.surfaceContainerLow,
                    decoration: const InputDecoration(border: InputBorder.none),
                    items: AccountType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getAccountTypeName(type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedType = value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Icon Selection
              Text(
                'Icono',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableIcons.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final icon = _availableIcons[index];
                    final isSelected = _selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon = icon),
                      child: Container(
                        width: 56,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _selectedColor.withValues(alpha: 0.2)
                              : colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected
                              ? Border.all(color: _selectedColor, width: 2)
                              : null,
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? _selectedColor
                              : colors.onSurfaceVariant,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Color Selection
              Text(
                'Color',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: Colors.primaries.take(12).map((color) {
                  final isSelected = _selectedColor.value == color.value;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: color, width: 2)
                            : null,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.account == null ? 'Crear Cuenta' : 'Guardar Cambios',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAccountTypeName(AccountType type) {
    switch (type) {
      case AccountType.checking:
        return 'Cuenta Corriente';
      case AccountType.debit:
        return 'Cuenta Débito / Vista';
      case AccountType.creditCard:
        return 'Tarjeta de Crédito';
      case AccountType.cash:
        return 'Efectivo';
      case AccountType.digitalWallet:
        return 'Billetera Digital';
      case AccountType.savings:
        return 'Cuenta de Ahorro';
      case AccountType.investment:
        return 'Inversiones';
    }
  }
}
