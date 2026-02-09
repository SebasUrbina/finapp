import 'package:flutter/material.dart';
import 'package:finapp/domain/models/finance_models.dart';

/// Tags predefinidos disponibles para todos los usuarios
class PredefinedTags {
  PredefinedTags._();

  // ============================================================================
  // BUDGET GROUP - Necesidades vs Deseos
  // ============================================================================

  static const needs = Tag(
    id: 'tag_needs',
    name: 'Necesidades',
    type: TagType.budgetGroup,
    color: Color(0xFF2196F3), // Blue
  );

  static const wants = Tag(
    id: 'tag_wants',
    name: 'Deseos',
    type: TagType.budgetGroup,
    color: Color(0xFF9C27B0), // Purple
  );

  // ============================================================================
  // EXPENSE NATURE - Fijo vs Variable
  // ============================================================================

  static const fixed = Tag(
    id: 'tag_fixed',
    name: 'Fijo',
    type: TagType.expenseNature,
    color: Color(0xFFFF9800), // Orange
  );

  static const variable = Tag(
    id: 'tag_variable',
    name: 'Variable',
    type: TagType.expenseNature,
    color: Color(0xFF4CAF50), // Green
  );

  // ============================================================================
  // LIFE AREA - Áreas de vida
  // ============================================================================

  static const housing = Tag(
    id: 'tag_housing',
    name: 'Vivienda',
    type: TagType.lifeArea,
    color: Color(0xFF795548), // Brown
  );

  static const transport = Tag(
    id: 'tag_transport',
    name: 'Transporte',
    type: TagType.lifeArea,
    color: Color(0xFF009688), // Teal
  );

  static const food = Tag(
    id: 'tag_food',
    name: 'Alimentación',
    type: TagType.lifeArea,
    color: Color(0xFFFF5722), // Deep Orange
  );

  static const health = Tag(
    id: 'tag_health',
    name: 'Salud',
    type: TagType.lifeArea,
    color: Color(0xFFE91E63), // Pink
  );

  static const education = Tag(
    id: 'tag_education',
    name: 'Educación',
    type: TagType.lifeArea,
    color: Color(0xFF3F51B5), // Indigo
  );

  static const entertainment = Tag(
    id: 'tag_entertainment',
    name: 'Entretenimiento',
    type: TagType.lifeArea,
    color: Color(0xFFFFEB3B), // Yellow
  );

  static const shopping = Tag(
    id: 'tag_shopping',
    name: 'Compras',
    type: TagType.lifeArea,
    color: Color(0xFF00BCD4), // Cyan
  );

  static const utilities = Tag(
    id: 'tag_utilities',
    name: 'Servicios',
    type: TagType.lifeArea,
    color: Color(0xFF607D8B), // Blue Grey
  );

  // ============================================================================
  // OWNERSHIP - Personal vs Compartido
  // ============================================================================

  static const personal = Tag(
    id: 'tag_personal',
    name: 'Personal',
    type: TagType.ownership,
    color: Color(0xFF673AB7), // Deep Purple
  );

  static const shared = Tag(
    id: 'tag_shared',
    name: 'Compartido',
    type: TagType.ownership,
    color: Color(0xFFFF9800), // Orange
  );

  // ============================================================================
  // HELPERS
  // ============================================================================

  /// Lista completa de todos los tags predefinidos
  static const List<Tag> all = [
    // Budget Group
    needs,
    wants,

    // Expense Nature
    fixed,
    variable,

    // Life Area
    housing,
    transport,
    food,
    health,
    education,
    entertainment,
    shopping,
    utilities,

    // Ownership
    personal,
    shared,
  ];

  /// Obtener un tag predefinido por su ID
  static Tag? getById(String id) {
    try {
      return all.firstWhere((tag) => tag.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Obtener todos los tags de un tipo específico
  static List<Tag> byType(TagType type) {
    return all.where((tag) => tag.type == type).toList();
  }

  /// Verificar si un ID corresponde a un tag predefinido
  static bool isPredefined(String id) {
    return all.any((tag) => tag.id == id);
  }
}
