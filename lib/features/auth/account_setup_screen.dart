import 'package:finapp/domain/models/finance_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'auth_constants.dart';

import 'controllers/setup_controller.dart';
import 'auth_controller.dart';

/// Screen shown during onboarding to create the first account
class AccountSetupScreen extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const AccountSetupScreen({super.key, this.onComplete});

  @override
  ConsumerState<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends ConsumerState<AccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController(text: '0');
  AccountType _selectedType = AccountType.debit;

  final Map<AccountType, IconData> _accountIcons = {
    AccountType.checking: Icons.account_balance,
    AccountType.debit: Icons.account_balance_wallet,
    AccountType.creditCard: Icons.credit_card,
    AccountType.cash: Icons.payments,
    AccountType.digitalWallet: Icons.phone_android,
    AccountType.savings: Icons.savings,
    AccountType.investment: Icons.trending_up,
  };

  final Map<AccountType, String> _accountLabels = {
    AccountType.checking: 'Cuenta Corriente',
    AccountType.debit: 'Cuenta Vista/RUT',
    AccountType.creditCard: 'Tarjeta de Crédito',
    AccountType.cash: 'Efectivo',
    AccountType.digitalWallet: 'Billetera Digital',
    AccountType.savings: 'Ahorro',
    AccountType.investment: 'Inversión',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    final account = Account(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _selectedType,
      balance: Money(double.tryParse(_balanceController.text) ?? 0),
      icon: _accountIcons[_selectedType],
      color: AuthConstants.primaryPurple,
    );
    // No local setState needed

    try {
      // SetupController handles logic but NOT state loading for setup steps at the controller level?
      // Actually SetupController DOES handle loading state now (AsyncNotifier), so we can watch it or check it.
      // But here we are just triggering the action. we use ref.read
      await ref.read(setupControllerProvider.notifier).createAccount(account);

      // After successful account creation, complete setup
      // We do this here directly because SetupWrapper might be disposed
      if (mounted) {
        // This will trigger AuthWrapper to rebuild and likely dispose this screen
        ref.read(authControllerProvider.notifier).completeSetup();
        // widget.onComplete() is no longer needed for logic, maybe still for navigation if it wasn't replaced
        // bu since completeSetup changes the auth state, AuthWrapper should handle the switch.
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al crear cuenta: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(setupControllerProvider);
    final isLoading = setupState.isLoading;

    ref.listen(setupControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${next.error}')));
      }
    });
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AuthConstants.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Icon
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AuthConstants.primaryPurple.withValues(
                              alpha: 0.1,
                            ),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        size: 50,
                        color: AuthConstants.primaryPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  Text(
                    'Crea tu primera cuenta',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AuthConstants.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Necesitas al menos una cuenta para registrar tus gastos e ingresos.',
                    textAlign: TextAlign.center,
                    style: AuthConstants.authSubheaderStyle,
                  ),
                  const SizedBox(height: 32),
                  // Account Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la cuenta',
                      hintText: 'Ej: Cuenta RUT, Efectivo, etc.',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa un nombre para la cuenta';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Account Type
                  Text(
                    'Tipo de cuenta',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AuthConstants.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AccountType.values.map((type) {
                      final isSelected = _selectedType == type;
                      return ChoiceChip(
                        label: Text(_accountLabels[type] ?? ''),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedType = type);
                          }
                        },
                        selectedColor: AuthConstants.primaryPurple,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Initial Balance
                  TextFormField(
                    controller: _balanceController,
                    decoration: InputDecoration(
                      labelText: 'Saldo inicial (opcional)',
                      hintText: '0',
                      prefixText: '\$ ',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          double.tryParse(value) == null) {
                        return 'Ingresa un número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  // Create Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _createAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AuthConstants.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Crear cuenta',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
