import 'package:flutter/material.dart';

class AppColors {
  static const ink = Color(0xFF12242E);
  static const surface = Color(0xFF1B3540);
  static const surface2 = Color(0xFF22404D);
  static const line = Color(0xFF2C4E5B);
  static const text = Color(0xFFEAF2F0);
  static const muted = Color(0xFF7FA0A3);

  static const high = Color(0xFFFF6859); // priorité élevée
  static const med = Color(0xFFFFB84D);  // priorité moyenne
  static const low = Color(0xFF4DD9C0);  // priorité basse
  static const accent = Color(0xFF4DD9C0);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.ink,
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        surface: AppColors.surface,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        bodyMedium: TextStyle(color: AppColors.text, fontSize: 14),
        labelSmall: TextStyle(
          color: AppColors.muted,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.muted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.ink,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
    );
  }
}

/// Retourne la couleur associée à une priorité.
Color priorityColor(String priority) {
  switch (priority) {
    case 'Élevée':
      return AppColors.high;
    case 'Moyenne':
      return AppColors.med;
    default:
      return AppColors.low;
  }
}