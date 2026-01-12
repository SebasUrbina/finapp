import 'package:flutter/material.dart';
import 'package:finapp/core/theme/theme_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggleButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final controller = ref.read(themeModeProvider.notifier);

    final isDark = themeMode == ThemeMode.dark;

    return IconButton(
      onPressed: controller.toggle,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          key: ValueKey(isDark),
        ),
      ),
      tooltip: isDark ? 'Light mode' : 'Dark mode',
    );
  }
}
