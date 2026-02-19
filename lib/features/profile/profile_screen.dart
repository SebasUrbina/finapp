import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/profile_provider.dart';
import 'widgets/profile_header.dart';
import 'widgets/settings_widgets.dart';
import '../accounts/account_list_screen.dart';
import '../auth/auth_controller.dart';
import '../settings/settings_screen.dart';
import '../about/about_screen.dart';

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
                    icon: Icons.key_outlined,
                    title: 'Cambiar Contraseña',
                    onTap: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      final email = user?.email;
                      if (email == null) return;
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: email,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Email de restablecimiento enviado a $email',
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.green.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Error al enviar el email. Intenta de nuevo.',
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      }
                    },
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
                title: 'Configuración', // Settings
                children: [
                  SettingsTile(
                    icon: Icons.settings_outlined,
                    title: 'Ajustes',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: 'Acerca de',
                    showDivider: false,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).signOut();
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
}
