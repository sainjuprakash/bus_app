import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFF0F4F8),
    onSurface: Color(0xFf1B3A57),
    primary: Color(0xFFFAFAFA),
    onPrimary: Color(0xFF1F2833),
    secondary: Color(0xFFFAFAFA),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFf1B3A57),
    foregroundColor: Colors.white, // AppBar text color for light theme
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black87),
    titleMedium: TextStyle(color: Colors.black54),
    labelLarge:
        TextStyle(color: Colors.white), // TextButton text color for light theme
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFF1B3A57), // Button text color
    ),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF2A3542),
    onSurface: Color(0xFFF0F4F8),
    primary: Color(0xFF1F2833),
    onPrimary: Color(0xFFF0F4F8),
    secondary: Color(0xFF2A3542),
    // Text color for surface
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F2833),
    foregroundColor: Colors.white, // AppBar text color for dark theme
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white70),
    titleMedium: TextStyle(color: Colors.white60),
    labelLarge:
        TextStyle(color: Colors.black), // TextButton text color for dark theme
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor:
          const Color(0xFF00B7C2), // Button text color for dark theme
    ),
  ),
);
