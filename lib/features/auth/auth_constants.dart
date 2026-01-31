import 'package:flutter/material.dart';

class AuthConstants {
  // Colors from the design
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color secondaryPurple = Color(0xFFEDE7F6);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textLight = Color(0xFF6B7280);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE0E7FF), // Very light blue/purple
      Colors.white,
    ],
  );

  // Text Styles (can be used if theme is not enough)
  static const TextStyle authHeaderStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textDark,
  );

  static const TextStyle authSubheaderStyle = TextStyle(
    fontSize: 16,
    color: textLight,
  );
}
