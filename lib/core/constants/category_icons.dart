import 'package:flutter/material.dart';
import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/core/theme/app_theme.dart';

class CategoryIconMapper {
  static const Map<CategoryIcon, IconData> _icons = {
    CategoryIcon.home: Icons.home,
    CategoryIcon.shoppingCart: Icons.shopping_cart,
    CategoryIcon.group: Icons.group,
    CategoryIcon.bus: Icons.directions_bus,
    CategoryIcon.restaurant: Icons.restaurant,
    CategoryIcon.movie: Icons.movie,
    CategoryIcon.hospital: Icons.local_hospital,
    CategoryIcon.receipt: Icons.receipt_long,
    CategoryIcon.payments: Icons.payments,
    CategoryIcon.trendingUp: Icons.trending_up,
    CategoryIcon.bank: Icons.account_balance,
    CategoryIcon.creditCard: Icons.credit_card,
    CategoryIcon.school: Icons.school,
    CategoryIcon.fitness: Icons.fitness_center,
    CategoryIcon.flight: Icons.flight,
    CategoryIcon.car: Icons.directions_car,
    CategoryIcon.pets: Icons.pets,
    CategoryIcon.tools: Icons.build,
    CategoryIcon.redeem: Icons.redeem,
    CategoryIcon.laptop: Icons.laptop,
  };

  static IconData toIcon(CategoryIcon icon) {
    return _icons[icon] ?? Icons.help_outline;
  }

  static Color toColor(CategoryIcon icon, BuildContext context) {
    final categoryColors = Theme.of(context).extension<CategoryColors>();
    if (categoryColors == null) return Theme.of(context).colorScheme.primary;

    switch (icon) {
      case CategoryIcon.home:
        return categoryColors.utilities;
      case CategoryIcon.shoppingCart:
        return categoryColors.shopping;
      case CategoryIcon.group:
        return categoryColors.other;
      case CategoryIcon.bus:
        return categoryColors.transport;
      case CategoryIcon.restaurant:
        return categoryColors.food;
      case CategoryIcon.movie:
        return categoryColors.entertainment;
      case CategoryIcon.hospital:
        return categoryColors.health;
      case CategoryIcon.receipt:
        return categoryColors.utilities;
      case CategoryIcon.payments:
        return categoryColors.utilities;
      case CategoryIcon.trendingUp:
        return categoryColors.food;
      case CategoryIcon.bank:
        return categoryColors.transport;
      case CategoryIcon.creditCard:
        return categoryColors.shopping;
      case CategoryIcon.school:
        return categoryColors.education;
      case CategoryIcon.fitness:
        return categoryColors.health;
      case CategoryIcon.flight:
        return categoryColors.transport;
      case CategoryIcon.car:
        return categoryColors.transport;
      case CategoryIcon.pets:
        return categoryColors.health;
      case CategoryIcon.tools:
        return categoryColors.utilities;
      case CategoryIcon.redeem:
        return categoryColors.shopping;
      case CategoryIcon.laptop:
        return categoryColors.entertainment;
    }
  }
}
