import 'package:finapp/data/providers/finance_providers.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/dashboard/dashboard_controller.dart';
import 'package:finapp/features/dashboard/widgets/category_settings_modal/add_category_box.dart';
import 'package:finapp/features/dashboard/widgets/category_settings_modal/category_box.dart';
import 'package:finapp/features/dashboard/widgets/category_settings_modal/category_form_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySettingsModal extends ConsumerWidget {
  const CategorySettingsModal({super.key});

  void _showAddCategory(
    BuildContext context,
    WidgetRef ref,
    List<Tag> allTags,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryFormSheet(
        allTags: allTags,
        onSave: (name, icon, tagIds, defaultSplit) {
          final newCategory = Category(
            id: 'c_${DateTime.now().millisecondsSinceEpoch}',
            name: name,
            icon: icon,
            tagIds: tagIds,
            defaultSplit: defaultSplit,
          );
          ref.read(categoriesProvider.notifier).addCategory(newCategory);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditCategory(
    BuildContext context,
    WidgetRef ref,
    Category category,
    List<Tag> allTags,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryFormSheet(
        allTags: allTags,
        initialCategory: category,
        onSave: (name, icon, tagIds, defaultSplit) {
          final updatedCategory = Category(
            id: category.id,
            name: name,
            icon: icon,
            tagIds: tagIds,
            defaultSplit: defaultSplit,
          );
          ref.read(categoriesProvider.notifier).updateCategory(updatedCategory);
          Navigator.pop(context);
        },
        onDelete: () {
          ref.read(categoriesProvider.notifier).deleteCategory(category.id);
          Navigator.pop(context); // Close sheet
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Watch the state directly to rebuild when categories/tags change
    final asyncState = ref.watch(dashboardStateProvider);
    // Handle loading/error states gracefully or show loading
    final state = asyncState.valueOrNull;

    if (state == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final categories = state.categories;
    final allTags = state.tags;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        gradient: isDark
            ? null
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF3E7FF), Colors.white],
                stops: [0.0, 0.4],
              ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: colors.onSurfaceVariant.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Custom Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.cardTheme.color,
                      foregroundColor: colors.onSurface,
                      padding: const EdgeInsets.all(12),
                      elevation: 2,
                      shadowColor: Colors.black12,
                    ),
                  ),
                ),
                Text(
                  'Seleccionar Categoría',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Organiza y personaliza tus categorías',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 32),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 40),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.75,
                ),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Add is first in the image
                    return AddCategoryBox(
                      onTap: () => _showAddCategory(context, ref, allTags),
                    );
                  }
                  final category = categories[index - 1];
                  return CategoryBox(
                    category: category,
                    onEdit: () =>
                        _showEditCategory(context, ref, category, allTags),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
