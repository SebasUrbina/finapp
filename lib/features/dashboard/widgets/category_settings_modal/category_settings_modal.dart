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
        onSave: (name, icon, tagIds) {
          final newCategory = Category(
            id: 'c_${DateTime.now().millisecondsSinceEpoch}',
            name: name,
            icon: icon,
            tagIds: tagIds,
          );
          ref
              .read(dashboardControllerProvider.notifier)
              .addCategory(newCategory);
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
        onSave: (name, icon, tagIds) {
          final updatedCategory = Category(
            id: category.id,
            name: name,
            icon: icon,
            tagIds: tagIds,
          );
          ref
              .read(dashboardControllerProvider.notifier)
              .updateCategory(updatedCategory);
          Navigator.pop(context);
        },
        onDelete: () {
          ref
              .read(dashboardControllerProvider.notifier)
              .deleteCategory(category.id);
          Navigator.pop(context); // Close sheet
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Watch the state directly to rebuild when categories/tags change
    final state = ref.watch(dashboardControllerProvider);
    final categories = state.categories;
    final allTags = state.tags;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorías',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: colors.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Organiza y personaliza tus gastos',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),

          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == categories.length) {
                  return AddCategoryBox(
                    onTap: () => _showAddCategory(context, ref, allTags),
                  );
                }
                final category = categories[index];
                return CategoryBox(
                  category: category,
                  onEdit: () =>
                      _showEditCategory(context, ref, category, allTags),
                  onTap: () {},
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
