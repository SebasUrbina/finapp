import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/accounts/widgets/account_card_item.dart';
import 'package:finapp/features/accounts/widgets/account_form_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finapp/features/accounts/account_controller.dart';

class AccountListScreen extends ConsumerWidget {
  const AccountListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('Mis Cuentas'),
        centerTitle: true,
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Text(
              'Gestiona tus cuentas bancarias y efectivo en un solo lugar.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: accountsAsync.when(
              skipLoadingOnReload:
                  true, // Prevents flicker during silent refresh
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (accounts) => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return AccountCardItem(
                    account: account,
                    onEdit: () => _showAccountForm(context, ref, account),
                    onDelete: () => {}, // Handled inside the form modal
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAccountForm(context, ref),
        label: const Text('Añadir Cuenta'),
        icon: const Icon(Icons.add),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 4,
      ),
    );
  }

  void _showAccountForm(
    BuildContext context,
    WidgetRef ref, [
    Account? account,
  ]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AccountFormSheet(
        account: account,
        onSave: (updatedAccount) {
          if (account == null) {
            ref
                .read(accountControllerProvider.notifier)
                .addAccount(updatedAccount);
          } else {
            ref
                .read(accountControllerProvider.notifier)
                .updateAccount(updatedAccount);
          }
        },
        onDelete: (accountId) {
          ref.read(accountControllerProvider.notifier).deleteAccount(accountId);
        },
      ),
    );
  }
}
