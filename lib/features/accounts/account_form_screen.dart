import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'account_controller.dart';
import 'widgets/account_form_widgets.dart';
import 'dart:math';

class AccountFormScreen extends ConsumerStatefulWidget {
  final Account? account;

  const AccountFormScreen({super.key, this.account});

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
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

  void _save() {
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

      if (widget.account == null) {
        ref.read(accountControllerProvider.notifier).addAccount(account);
      } else {
        ref.read(accountControllerProvider.notifier).updateAccount(account);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(widget.account == null ? 'Nueva Cuenta' : 'Editar Cuenta'),
        backgroundColor: colors.surface,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Preview
              AccountPreviewIcon(icon: _selectedIcon, color: _selectedColor),
              const SizedBox(height: 32),

              const AccountFormSectionTitle(title: 'Información General'),
              const SizedBox(height: 16),
              AccountFormTextField(
                controller: _nameController,
                label: 'Nombre de la cuenta',
                icon: Icons.label_outline,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              AccountFormTextField(
                controller: _balanceController,
                label: 'Saldo Actual',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 24),

              const AccountFormSectionTitle(title: 'Tipo de Cuenta'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<AccountType>(
                    value: _selectedType,
                    dropdownColor: colors.surfaceContainerLow,
                    focusColor: Colors.transparent,
                    decoration: const InputDecoration(border: InputBorder.none),
                    items: AccountType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          _getAccountTypeName(type),
                          style: theme.textTheme.bodyLarge,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedType = value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const AccountFormSectionTitle(title: 'Icono'),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableIcons.length,
                  itemBuilder: (context, index) {
                    final icon = _availableIcons[index];
                    final isSelected = _selectedIcon == icon;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
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
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              const AccountFormSectionTitle(title: 'Color'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: Colors.primaries.take(12).map((color) {
                  final isSelected = _selectedColor.value == color.value;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      padding: EdgeInsets.all(isSelected ? 3 : 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: color.withValues(alpha: 0.4),
                                width: 2,
                              )
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

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.account == null ? 'Crear Cuenta' : 'Guardar Cambios',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
