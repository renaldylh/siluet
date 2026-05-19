import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palette warna mewah: Sleek Instagram Dark Mode (Deep Slate Black & Champagne Gold)
  static const Color backgroundColor = Color(0xFF090A0F); // Black Obsidian
  static const Color cardColor = Color(0xFF14161D); // Dark Charcoal
  static const Color primaryColor = Color(0xFFFFFFFF); // Pure White
  static const Color accentColor = Color(0xFFE5A93B); // Champagne Gold
  static const Color mutedColor = Color(0xFF8E8E93); // iOS Muted Gray
  static const Color dividerColor = Color(0xFF262626); // Modern thin border

  static ThemeData get premiumDarkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      cardColor: cardColor,
      dividerColor: dividerColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        background: backgroundColor,
        surface: cardColor,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        headlineMedium: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        titleLarge: const TextStyle(color: primaryColor, fontWeight: FontWeight.w700, letterSpacing: -0.2),
        bodyMedium: const TextStyle(color: mutedColor, fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5, color: primaryColor),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: mutedColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // Capsule style
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.2),
        ),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: dividerColor, width: 0.8),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
    );
  }
}
