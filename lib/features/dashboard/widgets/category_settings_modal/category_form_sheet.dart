import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/constants/category_icons.dart';

import 'package:flutter/material.dart' hide Split;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryFormSheet extends ConsumerStatefulWidget {
  final List<Tag> allTags;
  final Category? initialCategory;
  final Function(
    String name,
    CategoryIcon icon,
    List<String> tagIds,
    Split? defaultSplit,
  )
  onSave;
  final VoidCallback? onDelete;

  const CategoryFormSheet({
    super.key,
    required this.allTags,
    this.initialCategory,
    required this.onSave,
    this.onDelete,
  });

  @override
  ConsumerState<CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends ConsumerState<CategoryFormSheet> {
  late final TextEditingController _nameController;
  late CategoryIcon _selectedIcon;
  late List<String> _selectedTagIds;
  Split? _defaultSplit;

  final List<CategoryIcon> _availableIcons = CategoryIcon.values;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialCategory?.name);
    _selectedIcon = widget.initialCategory?.icon ?? CategoryIcon.home;
    _selectedTagIds = List.from(widget.initialCategory?.tagIds ?? []);
    _defaultSplit = widget.initialCategory?.defaultSplit;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isEditing = widget.initialCategory != null;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEditing ? 'Editar Categoría' : 'Nueva Categoría',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditing && widget.onDelete != null)
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmation(context);
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      hintText: 'Ej: Mascotas, Gimnasio...',
                      filled: true,
                      fillColor: colors.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Icono', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _availableIcons.length,
                      itemBuilder: (context, index) {
                        final iconEnum = _availableIcons[index];
                        final isSelected = _selectedIcon == iconEnum;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedIcon = iconEnum),
                          child: Container(
                            width: 50,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? CategoryIconMapper.toColor(
                                      iconEnum,
                                      context,
                                    ).withValues(alpha: 0.2)
                                  : colors.surfaceContainerHighest.withValues(
                                      alpha: 0.3,
                                    ),
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? Border.all(
                                      color: CategoryIconMapper.toColor(
                                        iconEnum,
                                        context,
                                      ),
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Icon(
                              CategoryIconMapper.toIcon(iconEnum),
                              color: isSelected
                                  ? CategoryIconMapper.toColor(
                                      iconEnum,
                                      context,
                                    )
                                  : colors.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Tags sugeridos', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.allTags.map((tag) {
                      final isSelected = _selectedTagIds.contains(tag.id);
                      return FilterChip(
                        label: Text(tag.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTagIds.add(tag.id);
                            } else {
                              _selectedTagIds.remove(tag.id);
                            }
                          });
                        },
                        selectedColor: colors.primaryContainer,
                        checkmarkColor: colors.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? colors.onPrimaryContainer
                              : colors.onSurface,
                          fontSize: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Split Configuration Section
                  // CategorySplitConfigurator(
                  //   initialSplit: _defaultSplit,
                  //   onSplitChanged: (split) {
                  //     setState(() {
                  //       _defaultSplit = split;
                  //     });
                  //   },
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  widget.onSave(
                    _nameController.text,
                    _selectedIcon,
                    _selectedTagIds,
                    _defaultSplit,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                isEditing ? 'Guardar Cambios' : 'Guardar Categoría',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar categoría?'),
        content: const Text(
          'Esta acción no se puede deshacer. Se mantendrán las transacciones pero sin categoría.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              widget.onDelete?.call();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
