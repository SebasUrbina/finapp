import 'package:finapp/core/utils/currency_formatter.dart';
import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows a modal bottom sheet to pick an [Account].
/// Calls [onSelected] with the chosen account.
void showAccountPicker(
  BuildContext context,
  WidgetRef ref, {
  required void Function(Account account) onSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final accountsAsync = ref.watch(accountsProvider);

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Seleccionar Cuenta',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: accountsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Text(
                      'Error al cargar cuentas',
                      style: TextStyle(color: colors.error),
                    ),
                  ),
                  data: (accounts) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: (account.color ?? colors.primary)
                              .withValues(alpha: 0.12),
                          child: Icon(
                            account.icon ??
                                Icons.account_balance_wallet_rounded,
                            color: account.color ?? colors.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          account.name,
                          style: theme.textTheme.titleSmall,
                        ),
                        subtitle: Text(
                          account.balance.toCurrency(),
                          style: theme.textTheme.bodySmall,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onTap: () {
                          onSelected(account);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    ),
  );
}

/// Shows a modal bottom sheet to pick a [Category].
/// Calls [onSelected] with the chosen category.
void showCategoryPicker(
  BuildContext context,
  WidgetRef ref, {
  required void Function(Category category) onSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final categoriesAsync = ref.watch(categoriesProvider);

        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Seleccionar Categoría',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: categoriesAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Text(
                      'Error al cargar categorías',
                      style: TextStyle(color: colors.error),
                    ),
                  ),
                  data: (categories) => GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return InkWell(
                        onTap: () {
                          onSelected(cat);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: colors.primary.withValues(
                                  alpha: 0.12,
                                ),
                                child: Icon(
                                  cat.iconData,
                                  color: colors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Text(
                                  cat.name,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
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
