import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color _lightPrimaryColor = Colors.black; // Black for text/icons
  static const Color _lightBackgroundColor = Color(0xFFFFFFFF); // Pure White
  static const Color _lightSurfaceColor =
      Color(0xFFF5F5F5); // Light Grey for cards
  static const Color _lightAccentColor =
      Color(0xFFBDBDBD); // Medium Grey for accents
  static const Color _lightDividerColor =
      Color(0xFFE0E0E0); // Light Divider Grey

  // Dark Theme Colors
  static const Color _darkPrimaryColor = Colors.white; // White for text/icons
  static const Color _darkBackgroundColor = Color(0xFF121212); // Almost Black
  static const Color _darkSurfaceColor =
      Color(0xFF1E1E1E); // Dark Grey for cards
  static const Color _darkAccentColor =
      Color(0xFF424242); // Medium Grey for accents
  static const Color _darkDividerColor = Color(0xFF2E2E2E); // Divider Grey

  // Typography
  static const String _fontFamily = 'Roboto';

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _lightPrimaryColor,
    scaffoldBackgroundColor: _lightBackgroundColor,
    cardColor: _lightSurfaceColor,
    dividerColor: _lightDividerColor,
    iconTheme: const IconThemeData(color: _lightPrimaryColor),
    appBarTheme: const AppBarTheme(
      backgroundColor: _lightBackgroundColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: _lightPrimaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: _lightPrimaryColor),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: _lightPrimaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        color: _lightPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        color: _lightPrimaryColor,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _lightAccentColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightAccentColor,
        foregroundColor: Colors.white,
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _darkPrimaryColor,
    scaffoldBackgroundColor: _darkBackgroundColor,
    cardColor: _darkSurfaceColor,
    dividerColor: _darkDividerColor,
    iconTheme: const IconThemeData(color: _darkPrimaryColor),
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBackgroundColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: _darkPrimaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: _darkPrimaryColor),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: _darkPrimaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        color: _darkPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        color: _darkPrimaryColor,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _darkAccentColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkAccentColor,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
