import 'package:flutter/material.dart';
import 'package:finapp/domain/models/finance_models.dart';

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
}
