import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.black,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: TextTheme(
    headlineLarge: const TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
    headlineMedium: const TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w600),
    bodyLarge: const TextStyle(color: Colors.black87, fontSize: 16),
    bodyMedium: const TextStyle(color: Colors.black54, fontSize: 14),
    labelSmall: TextStyle(color: Colors.grey[600]),
  ),
  cardColor: Colors.grey[100],
  dividerColor: Colors.grey[400],
  iconTheme: const IconThemeData(color: Colors.black),
  colorScheme: ColorScheme.light(
    primary: Colors.black,
    secondary: Colors.grey[800]!,
    background: Colors.white,
    onPrimary: Colors.white,
    surface: Colors.grey[200]!,
    onSurface: Colors.black87,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[400]!),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(8),
    ),
    hintStyle: TextStyle(color: Colors.grey[600]),
  ),
);
