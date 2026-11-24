import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF141212);
  static const Color cardBackground = Color(0xFF1B1714);
  static const Color surface = Color(0xFF1F1C1B);
  static const Color surfaceLight = Color(0xFF2B2726);
  static const Color borderSubtle = Color(0xFF2B2620);

  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentGoldSoft = Color(0xFFD9A04A);
  static const Color accentGoldDark = Color(0xFFB88030);
  static const Color accentBronze = Color(0xFF5A4425);

  static const Color accentGreen = Color(0xFF1B2E23);
  static const Color accentGreenBorder = Color(0xFF2C4A38);
  static const Color accentGreenText = Color(0xFF5BB982);
  static const Color snackbarSuccess = Color(0xFF1B4D3E);

  static const Color error = Color(0xFFC84B59);

  static const Color textPrimary = Color(0xFFF5EFEB);
  static const Color textSecondary = Color(0xFFA69E99);
  static const Color textMuted = Color(0xFF8A8178);

  static const List<String> coverColors = [
    '#8C3B54',
    '#2D6347',
    '#A66D43',
    '#37556B',
    '#C75B4C',
  ];

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: borderSubtle, width: 1),
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: accentGold,

      textTheme: GoogleFonts.playfairDisplayTextTheme().apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),

      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        secondary: accentGreen,
        surface: surface,
        error: error,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(
          color: textSecondary,
          fontFamily: 'sans-serif',
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentGold, width: 1.2),
        ),
      ),
    );
  }
}
