import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color seedPrimary = Color.fromARGB(255, 2, 60, 250);

  // --- TEMA CLARO ---
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedPrimary,
      brightness: Brightness.light,
      surface: const Color(0xFFF8FAFC),
      surfaceContainerHighest: const Color(0xFFF1F5F9),
    ),
    textTheme: GoogleFonts.outfitTextTheme(_lightTextTheme),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white,
    ),
    extensions: [CategoryColors.light],
  );

  // --- TEMA OSCURO ---
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedPrimary,
      brightness: Brightness.dark,
      surface: const Color(0xFF0F172A),
      surfaceContainerHighest: const Color(0xFF1E293B),
    ),
    textTheme: GoogleFonts.outfitTextTheme(_darkTextTheme),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: const Color(0xFF1E293B),
    ),
    extensions: [CategoryColors.dark],
  );

  static final TextTheme _lightTextTheme = const TextTheme(
    headlineLarge: TextStyle(
      color: Color(0xFF0F172A),
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
    headlineMedium: TextStyle(
      color: Color(0xFF0F172A),
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    titleLarge: TextStyle(
      color: Color(0xFF0F172A),
      fontWeight: FontWeight.w700,
      fontSize: 20,
    ),
    titleMedium: TextStyle(
      color: Color(0xFF0F172A),
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    bodyLarge: TextStyle(color: Color(0xFF0F172A), fontSize: 16),
    bodyMedium: TextStyle(color: Color(0xFF64748B), fontSize: 14),
    bodySmall: TextStyle(color: Color(0xFF64748B), fontSize: 12),
    labelSmall: TextStyle(
      color: Color(0xFF64748B),
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: Color(0xFF0F172A),
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );

  static final TextTheme _darkTextTheme = const TextTheme(
    headlineLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 20,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    bodyLarge: TextStyle(color: Color(0xFFF1F5F9), fontSize: 16),
    bodyMedium: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
    bodySmall: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
    labelSmall: TextStyle(
      color: Color(0xFF94A3B8),
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}

@immutable
class CategoryColors extends ThemeExtension<CategoryColors> {
  final Color health;
  final Color transport;
  final Color food;
  final Color entertainment;
  final Color utilities;
  final Color education;
  final Color shopping;
  final Color other;

  const CategoryColors({
    required this.health,
    required this.transport,
    required this.food,
    required this.entertainment,
    required this.utilities,
    required this.education,
    required this.shopping,
    required this.other,
  });

  @override
  CategoryColors copyWith({
    Color? health,
    Color? transport,
    Color? food,
    Color? entertainment,
    Color? utilities,
    Color? education,
    Color? shopping,
    Color? other,
  }) {
    return CategoryColors(
      health: health ?? this.health,
      transport: transport ?? this.transport,
      food: food ?? this.food,
      entertainment: entertainment ?? this.entertainment,
      utilities: utilities ?? this.utilities,
      education: education ?? this.education,
      shopping: shopping ?? this.shopping,
      other: other ?? this.other,
    );
  }

  @override
  CategoryColors lerp(ThemeExtension<CategoryColors>? other, double t) {
    if (other is! CategoryColors) return this;
    return CategoryColors(
      health: Color.lerp(health, other.health, t)!,
      transport: Color.lerp(transport, other.transport, t)!,
      food: Color.lerp(food, other.food, t)!,
      entertainment: Color.lerp(entertainment, other.entertainment, t)!,
      utilities: Color.lerp(utilities, other.utilities, t)!,
      education: Color.lerp(education, other.education, t)!,
      shopping: Color.lerp(shopping, other.shopping, t)!,
      other: Color.lerp(this.other, other.other, t)!,
    );
  }

  static const light = CategoryColors(
    health: Color(0xFF4ECDC4),
    transport: Color(0xFF4A90E2),
    food: Color(0xFFFF6B9D),
    entertainment: Color(0xFF9B59B6),
    utilities: Color(0xFFFFB74D),
    education: Color(0xFF4A90E2),
    shopping: Color(0xFFFF6B9D),
    other: Color(0xFF8E8E93),
  );

  static const dark = CategoryColors(
    health: Color(0xFF4FD1C5),
    transport: Color(0xFF63B3ED),
    food: Color(0xFFF687B3),
    entertainment: Color(0xFFB794F4),
    utilities: Color(0xFFFBD38D),
    education: Color(0xFF63B3ED),
    shopping: Color(0xFFF687B3),
    other: Color(0xFF94A3B8),
  );
}
