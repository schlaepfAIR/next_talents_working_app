import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6A1B9A); // Tief-Lila
  static const Color secondary = Color(0xFFCE93D8); // Lavendel
  static const Color accent = Color(0xFFC6FF00); // Neon-Lime
  static const Color electricBlue = Color(0xFF00B0FF); // Blau für Header
  static const Color darkGrey = Color(0xFF212121); // Texte, Icons
  static const Color lightGrey = Color(0xFFF5F5F5); // Sektionen, BG
}

class AppTheme {
  static final ThemeData themeData = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.electricBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.darkGrey,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: AppColors.darkGrey),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.secondary,
    ),
  );
}
