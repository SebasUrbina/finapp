import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = packageInfo.version;
      });
    } catch (e) {
      // Keep default version if package info fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Carenine',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Versión $_version',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tu asistente personal para gestionar finanzas de forma inteligente',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Features Section
            _buildSection(
              context,
              title: 'Características',
              icon: Icons.star,
              children: [
                _buildFeatureItem(
                  context,
                  icon: Icons.trending_up,
                  title: 'Seguimiento de gastos e ingresos',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.pie_chart,
                  title: 'Presupuestos por categoría',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.insights,
                  title: 'Análisis de insights financieros',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.account_balance,
                  title: 'Múltiples cuentas',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.label,
                  title: 'Etiquetas personalizadas',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.cloud_sync,
                  title: 'Sincronización en la nube',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Technology Section
            _buildSection(
              context,
              title: 'Tecnología',
              icon: Icons.code,
              children: [
                _buildInfoTile(
                  context,
                  icon: Icons.flutter_dash,
                  title: 'Flutter',
                  subtitle: 'Framework de desarrollo',
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.cloud,
                  title: 'Firebase',
                  subtitle: 'Autenticación y base de datos',
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.architecture,
                  title: 'Riverpod',
                  subtitle: 'Gestión de estado',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Legal Section
            _buildSection(
              context,
              title: 'Legal',
              icon: Icons.gavel,
              children: [
                _buildActionTile(
                  context,
                  icon: Icons.description,
                  title: 'Términos y Condiciones',
                  onTap: () {
                    _showComingSoon(context, 'Términos y Condiciones');
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.privacy_tip,
                  title: 'Política de Privacidad',
                  onTap: () {
                    _showComingSoon(context, 'Política de Privacidad');
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.library_books,
                  title: 'Licencias de código abierto',
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: 'Carenine',
                      applicationVersion: _version,
                      applicationIcon: Icon(
                        Icons.account_balance_wallet,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Support Section
            _buildSection(
              context,
              title: 'Soporte',
              icon: Icons.help,
              children: [
                _buildActionTile(
                  context,
                  icon: Icons.email,
                  title: 'Contacto',
                  subtitle: 'support@carenine.app',
                  onTap: () {
                    _showComingSoon(context, 'Contacto');
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.bug_report,
                  title: 'Reportar un problema',
                  onTap: () {
                    _showComingSoon(context, 'Reportar problema');
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    'Desarrollado con ❤️',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '© 2026 Carenine',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
          Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 20),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: colorScheme.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: const Text('Esta función estará disponible próximamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
