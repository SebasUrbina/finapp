import 'package:finapp/domain/models/finance_models.dart';

/// Categorías predefinidas que se pueden cargar automáticamente
/// para nuevos usuarios, facilitando el inicio rápido de la app.
class DefaultCategories {
  /// Lista de categorías predefinidas comunes para finanzas personales
  static List<Category> get predefinedCategories => [
    // Necesidades básicas
    const Category(id: 'c_rent', name: 'Arriendo', icon: CategoryIcon.home),
    const Category(
      id: 'c_supermarket',
      name: 'Supermercado',
      icon: CategoryIcon.shoppingCart,
    ),
    const Category(
      id: 'c_utilities',
      name: 'Servicios',
      icon: CategoryIcon.receipt,
    ),
    const Category(
      id: 'c_transport',
      name: 'Transporte',
      icon: CategoryIcon.bus,
    ),
    const Category(id: 'c_health', name: 'Salud', icon: CategoryIcon.hospital),

    // Gastos variables
    const Category(
      id: 'c_eating_out',
      name: 'Restaurantes',
      icon: CategoryIcon.restaurant,
    ),
    const Category(
      id: 'c_entertainment',
      name: 'Entretenimiento',
      icon: CategoryIcon.movie,
    ),
    const Category(
      id: 'c_shopping',
      name: 'Compras',
      icon: CategoryIcon.shoppingCart,
    ),

    // Otros
    const Category(
      id: 'c_education',
      name: 'Educación',
      icon: CategoryIcon.school,
    ),
    const Category(
      id: 'c_fitness',
      name: 'Deporte',
      icon: CategoryIcon.fitness,
    ),
    const Category(id: 'c_travel', name: 'Viajes', icon: CategoryIcon.flight),
    const Category(id: 'c_car', name: 'Automóvil', icon: CategoryIcon.car),
    const Category(id: 'c_pets', name: 'Mascotas', icon: CategoryIcon.pets),
    const Category(id: 'c_tech', name: 'Tecnología', icon: CategoryIcon.laptop),
    const Category(
      id: 'c_income',
      name: 'Ingresos',
      icon: CategoryIcon.trendingUp,
    ),
  ];
}
