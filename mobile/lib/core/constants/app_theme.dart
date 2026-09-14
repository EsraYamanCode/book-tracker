import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF141212);     // Sıcak koyu fon
  static const Color surface = Color(0xFF1F1C1B);        // Kart ve kutu arka planı
  static const Color surfaceLight = Color(0xFF2B2726);   // İkincil yüzey
  static const Color accentGold = Color(0xFFD4AF37);     // Altın sarısı vurgu
  static const Color textPrimary = Color(0xFFF5EFEB);    // Ana metin
  static const Color textSecondary = Color(0xFFA69E99);  // Soluk açıklama metni

  static const List<String> coverColors = [
    '#723348', // Mürdüm
    '#244D38', // Zeytin Yeşili
    '#8C5E3C', // Sıcak Kahve
    '#2C4251', // Gece Mavisi
    '#B35446', // Kiremit
  ];

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
        surface: surface,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: textSecondary, fontFamily: 'sans-serif'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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