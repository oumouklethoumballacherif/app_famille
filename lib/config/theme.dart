import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme configuration with support for RTL and gender-based colors
class AppTheme {
  // Primary Colors - Soft Sage Green Palette
  static const Color primaryColor = Color(0xFF8CBDB9); // Soft Sage
  static const Color primaryLight = Color(0xFFB8D8D6);
  static const Color primaryDark = Color(0xFF6A9B97);

  // Accent Colors - Warm Peach Palette
  static const Color accentColor = Color(0xFFFAD7A0); // Warm Peach
  static const Color accentLight = Color(0xFFFFE8C2);

  // Gender Colors - Softer versions
  static const Color maleColor = Color(0xFF7FB3D5); // Soft Blue
  static const Color maleColorLight = Color(0xFFD4E6F1);
  static const Color femaleColor = Color(0xFFF1948A); // Soft Pink
  static const Color femaleColorLight = Color(0xFFFADBD8);

  // Status Colors - Muted versions
  static const Color successColor = Color(0xFF82E0AA);
  static const Color warningColor = Color(0xFFF5B041);
  static const Color errorColor = Color(0xFFEC7063);
  static const Color deceasedColor = Color(0xFF95A5A6);

  // Background Colors - Cream/White
  static const Color backgroundColor = Color(0xFFFAF9F6); // Cream White
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF4A6572); // Soft Dark Grey
  static const Color textSecondary = Color(0xFF78909C); // Muted Blue Grey
  static const Color textLight = Colors.white;

  /// Light Theme
  static ThemeData lightTheme(bool isRtl) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        error: errorColor,
        // Make sure onPrimary is legible (white usually works well with sage)
        onPrimary: Colors.white,
        onSecondary: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white, // Cleaner look
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0, // flatter design
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Softer, rounder corners
          side: const BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ), // Subtle border
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textLight,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Softer corners
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.cairo(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor),
        ),
        labelStyle: GoogleFonts.cairo(color: textSecondary),
        hintStyle: GoogleFonts.cairo(
          color: textSecondary.withValues(alpha: 0.7),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor:
            textPrimary, // Dark text on light accent for readability
        elevation: 4,
      ),
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        displayLarge: GoogleFonts.cairo(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.cairo(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.cairo(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.cairo(fontSize: 16, color: textPrimary),
        bodyMedium: GoogleFonts.cairo(fontSize: 14, color: textPrimary),
        bodySmall: GoogleFonts.cairo(fontSize: 12, color: textSecondary),
      ),
    );
  }
}
