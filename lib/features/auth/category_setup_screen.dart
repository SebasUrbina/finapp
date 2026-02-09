import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_constants.dart';
import 'controllers/setup_controller.dart';

/// Screen shown during onboarding to optionally load predefined categories
class CategorySetupScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const CategorySetupScreen({super.key, required this.onComplete});

  @override
  ConsumerState<CategorySetupScreen> createState() =>
      _CategorySetupScreenState();
}

class _CategorySetupScreenState extends ConsumerState<CategorySetupScreen> {
  Future<void> _loadCategories() async {
    // We don't need local isLoading, the provider handles it.
    // But we keep the method to trigger the action.
    try {
      // Use read to trigger action
      await ref.read(setupControllerProvider.notifier).loadDefaultCategories();
      // Navigation is handled in listener or here if successful
      if (mounted) widget.onComplete();
    } catch (e) {
      // Error handling is also done via listener usually, but here we catch rethrown error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar categorías: $e')),
        );
      }
    }
  }

  void _skip() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider to keep it alive and get state
    final setupState = ref.watch(setupControllerProvider);
    final isLoading = setupState.isLoading;

    // Listen for errors
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Icon
                Container(
                  width: 120,
                  height: 120,
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
                    Icons.category_outlined,
                    size: 60,
                    color: AuthConstants.primaryPurple,
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                Text(
                  '¿Cargar categorías predefinidas?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AuthConstants.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                // Description
                Text(
                  'Te ayudaremos a comenzar con categorías comunes como Supermercado, Transporte, Restaurantes y más.',
                  textAlign: TextAlign.center,
                  style: AuthConstants.authSubheaderStyle,
                ),
                const SizedBox(height: 8),
                Text(
                  'Siempre podrás crear, editar o eliminar categorías después.',
                  textAlign: TextAlign.center,
                  style: AuthConstants.authSubheaderStyle.copyWith(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                // Buttons
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _loadCategories,
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
                            'Cargar categorías predefinidas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: isLoading ? null : _skip,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AuthConstants.primaryPurple,
                      side: const BorderSide(
                        color: AuthConstants.primaryPurple,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Omitir',
                      style: TextStyle(
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
      ),
    );
  }
}
