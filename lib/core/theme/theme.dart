import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFF0F4F8),
    onPrimary: Color(0xFFFFFFFF),
    surface: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFf1B3A57),
  ),
  // Define TextButton color for light mode
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Color(0xFF1B3A57), // Text color for light theme
    ),
  ),
);

ThemeData darkModel = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF0B0C10),
    onPrimary: Color(0xFF131B21),
    surface: Color(0xFF1F2833),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F2833),
  ),
  // Define TextButton color for dark mode
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Color(0xFF00B7C2), // Text color for dark theme
    ),
  ),
);
