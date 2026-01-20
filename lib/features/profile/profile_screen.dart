import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/profile_provider.dart';
import 'widgets/profile_header.dart';
import 'widgets/premium_banner.dart';
import 'widgets/settings_widgets.dart';
import '../accounts/account_list_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(profile: profile),
              const SizedBox(height: 24),

              // Premium Banner. Habilitar en un futuro
              // const PremiumBanner(),
              const SizedBox(height: 32),
              SettingsSection(
                title: 'Cuenta', // Account Settings
                children: [
                  SettingsTile(
                    icon: Icons.person_outline,
                    title: 'Información de la Cuenta',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.key_outlined,
                    title: 'Cambiar Contraseña',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.account_balance_outlined,
                    title: 'Mis Cuentas',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccountListScreen(),
                        ),
                      );
                    },
                  ),
                  // Note: Evaluar si incorporar en un futuro
                  // SettingsTile(
                  //   icon: Icons.devices_outlined,
                  //   title: 'Dispositivos',
                  //   onTap: () {},
                  // ),
                  // Todo: Incorporar integración con gmail
                  // SettingsTile(
                  //   icon: Icons.account_balance_outlined,
                  //   title: 'Conectar Bancos',
                  //   showDivider: false,
                  //   onTap: () {},
                  // ),
                ],
              ),
              const SizedBox(height: 24),
              SettingsSection(
                title: 'Ajustes', // Settings
                children: [
                  SettingsTile(
                    icon: Icons.settings_outlined,
                    title: 'Ajustes',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.help_outline,
                    title: 'Ayuda y Soporte',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: 'Acerca de',
                    showDivider: false,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
