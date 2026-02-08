import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finapp/features/settings/providers/settings_provider.dart';
import 'package:finapp/features/settings/widgets/settings_section.dart';
import 'package:finapp/features/settings/widgets/settings_tile.dart';
import 'package:finapp/features/settings/persons_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: Implementar idioma en un futuro
            // Language Section
            // SettingsSection(
            //   title: 'Idioma',
            //   children: [
            //     SettingsDropdown<AppLanguage>(
            //       icon: Icons.language,
            //       title: 'Idioma de la aplicación',
            //       subtitle: 'Selecciona tu idioma preferido',
            //       value: settings.language,
            //       items: AppLanguage.values
            //           .map(
            //             (lang) => DropdownMenuItem(
            //               value: lang,
            //               child: Text(lang.displayName),
            //             ),
            //           )
            //           .toList(),
            //       onChanged: (language) {
            //         if (language != null) {
            //           ref.read(settingsProvider.notifier).setLanguage(language);
            //         }
            //       },
            //       showDivider: false,
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 24),

            // TODO: Implementar moneda en un futuro
            // Currency Section
            // SettingsSection(
            //   title: 'Moneda',
            //   children: [
            //     SettingsDropdown<Currency>(
            //       icon: Icons.attach_money,
            //       title: 'Moneda predeterminada',
            //       subtitle: 'Selecciona la moneda para mostrar tus finanzas',
            //       value: settings.currency,
            //       items: Currency.values
            //           .map(
            //             (currency) => DropdownMenuItem(
            //               value: currency,
            //               child: Text(
            //                 '${currency.symbol} ${currency.displayName}',
            //               ),
            //             ),
            //           )
            //           .toList(),
            //       onChanged: (currency) {
            //         if (currency != null) {
            //           ref.read(settingsProvider.notifier).setCurrency(currency);
            //         }
            //       },
            //       showDivider: false,
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 24),

            // TODO: Implementar notificaciones en un futuro
            // Notifications Section
            // SettingsSection(
            //   title: 'Notificaciones',
            //   children: [
            //     SettingsSwitch(
            //       icon: Icons.notifications_active,
            //       title: 'Alertas de presupuesto',
            //       subtitle:
            //           'Recibe notificaciones cuando te acerques al límite de tu presupuesto',
            //       value: settings.notifications.budgetAlerts,
            //       onChanged: (value) {
            //         ref.read(settingsProvider.notifier).setBudgetAlerts(value);
            //       },
            //     ),
            //     SettingsSwitch(
            //       icon: Icons.alarm,
            //       title: 'Recordatorios diarios',
            //       subtitle: 'Recordatorio para registrar tus gastos del día',
            //       value: settings.notifications.dailyReminders,
            //       onChanged: (value) {
            //         ref
            //             .read(settingsProvider.notifier)
            //             .setDailyReminders(value);
            //       },
            //     ),
            //     SettingsSwitch(
            //       icon: Icons.calendar_today,
            //       title: 'Resumen semanal',
            //       subtitle: 'Recibe un resumen de tus gastos cada semana',
            //       value: settings.notifications.weeklyReports,
            //       onChanged: (value) {
            //         ref.read(settingsProvider.notifier).setWeeklyReports(value);
            //       },
            //     ),
            //     SettingsSwitch(
            //       icon: Icons.calendar_month,
            //       title: 'Resumen mensual',
            //       subtitle: 'Recibe un resumen de tus gastos cada mes',
            //       value: settings.notifications.monthlyReports,
            //       onChanged: (value) {
            //         ref
            //             .read(settingsProvider.notifier)
            //             .setMonthlyReports(value);
            //       },
            //       showDivider: false,
            //     ),
            //   ],
            // // ),
            // const SizedBox(height: 24),

            // Shared Expenses Section
            SettingsSection(
              title: 'Gastos Compartidos',
              children: [
                SettingsTile(
                  icon: Icons.people,
                  title: 'Gestionar Personas',
                  subtitle:
                      'Administra las personas con las que compartes gastos',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonsScreen(),
                      ),
                    );
                  },
                  showDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Data & Privacy Section
            SettingsSection(
              title: 'Datos y Privacidad',
              children: [
                SettingsTile(
                  icon: Icons.download,
                  title: 'Exportar datos',
                  subtitle: 'Descarga tus transacciones en formato CSV',
                  onTap: () {
                    _showExportDialog(context);
                  },
                ),
                // TODO: Implementar sincronización en un futuro
                // SettingsTile(
                //   icon: Icons.cloud_sync,
                //   title: 'Sincronización',
                //   subtitle: 'Tus datos se sincronizan automáticamente',
                //   trailing: Icon(
                //     Icons.check_circle,
                //     color: theme.colorScheme.primary,
                //   ),
                // ),
                // TODO: Implementar eliminación de cuenta en un futuro
                // SettingsTile(
                //   icon: Icons.delete_forever,
                //   title: 'Eliminar cuenta',
                //   subtitle: 'Borrar permanentemente todos tus datos',
                //   onTap: () {
                //     _showDeleteAccountDialog(context);
                //   },
                //   showDivider: false,
                // ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exportar datos'),
        content: const Text(
          'Esta función estará disponible próximamente. Podrás exportar todas tus transacciones en formato CSV.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer y perderás todos tus datos permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Función en desarrollo')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
