import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Color Palette
  static const Color primaryIndigo = Color(0xFF4F5DFF);
  static const Color primaryIndigoDark = Color(0xFF3A47E0);
  static const Color backgroundLight = Color(0xFFFAFAF8);
  static const Color cardWhite = Color(0xFFFFFFFF);
  
  // Trust & Consent Colors
  static const Color trustGreenBg = Color(0xFFE8F7EE);
  static const Color trustGreenText = Color(0xFF1E9E5A);

  // Neutral Typography & Borders
  static const Color textNearBlack = Color(0xFF111111);
  static const Color textGray = Color(0xFF6B7280);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color starGold = Color(0xFFFFB800);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primaryIndigo,
        surface: cardWhite,
        onPrimary: Colors.white,
        onSurface: textNearBlack,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textNearBlack,
          height: 1.2,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textNearBlack,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textNearBlack,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: textNearBlack,
          height: 1.4,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textGray,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cardWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textNearBlack),
        titleTextStyle: TextStyle(
          color: textNearBlack,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        color: cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryIndigo,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999), // Pill shape
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: cardWhite,
          foregroundColor: textNearBlack,
          side: const BorderSide(color: borderLight, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
