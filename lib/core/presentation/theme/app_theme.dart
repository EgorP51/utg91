import 'package:flutter/material.dart';

/// Centralized theme configuration for the entire app
/// Follows Material 3 with Apple-inspired minimalism
/// No inline colors allowed - all styling through ThemeData
class AppTheme {
  AppTheme._();

  // Color palette
  static const _primaryColor = Color(0xFF007AFF); // iOS blue
  static const _secondaryColor = Color(0xFF5856D6); // iOS purple
  static const _surfaceLight = Color(0xFFFAFAFA);
  static const _surfaceDark = Color(0xFF1C1C1E);

  // Rarity colors for mascot cards
  static const rarityCommon = Color(0xFF8E8E93);
  static const rarityRare = Color(0xFF007AFF);
  static const rarityEpic = Color(0xFF5856D6);
  static const rarityLegendary = Color(0xFFFF9500);

  /// Light theme with Apple-style minimalism
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _surfaceLight,
        surfaceContainer: Colors.white,
        onSurface: Colors.black87,
        onSurfaceVariant: Colors.black54,
      ),

      // Typography - San Francisco style
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card styling is handled per-widget due to SDK compatibility
      // Cards use rounded corners and zero elevation by default in Material 3

      // AppBar - clean and minimal
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _surfaceLight,
        foregroundColor: Colors.black87,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),

      // Bottom navigation - iOS style
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: _surfaceLight,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.black38,
        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        showUnselectedLabels: true,
      ),

      // Floating action button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: Colors.black12,
        thickness: 0.5,
        space: 1,
      ),
    );
  }

  /// Dark theme with Apple-style minimalism
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _surfaceDark,
        surfaceContainer: const Color(0xFF2C2C2E),
        onSurface: Colors.white,
        onSurfaceVariant: Colors.white70,
      ),

      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Card styling is handled per-widget due to SDK compatibility
      // Cards use rounded corners and zero elevation by default in Material 3

      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _surfaceDark,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Bottom navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: _surfaceDark,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.white38,
        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        showUnselectedLabels: true,
      ),

      // Floating action button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: Colors.white12,
        thickness: 0.5,
        space: 1,
      ),
    );
  }

  /// Helper method to get rarity color
  static Color getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return rarityCommon;
      case 'rare':
        return rarityRare;
      case 'epic':
        return rarityEpic;
      case 'legendary':
        return rarityLegendary;
      default:
        return rarityCommon;
    }
  }
}
