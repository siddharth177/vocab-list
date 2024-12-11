import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kLightColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 207, 214, 250));
var kDarkColorScheme = kLightColorScheme;
    // ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 226, 247, 235));

var kLightThemeData = ThemeData().copyWith(
  primaryColor: const Color.fromARGB(255, 207, 214, 250),
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: const Color.fromARGB(255, 207, 214, 250),
    foregroundColor: Colors.black,
  ),
  textTheme: GoogleFonts.openSansTextTheme(),
  cardTheme: const CardTheme().copyWith(
    color: const Color.fromARGB(255, 207, 214, 250),
    elevation: 5,
  ),
  // ListTile theme
  listTileTheme: const ListTileThemeData().copyWith(
    tileColor: const Color.fromARGB(255, 207, 214, 250),
    textColor: Colors.black,
  ),
  // SnackBar theme
  snackBarTheme: const SnackBarThemeData().copyWith(
    backgroundColor: const Color.fromARGB(255, 207, 214, 250),
    contentTextStyle: const TextStyle(color: Colors.black),
  ),
  // Dialog theme
  dialogTheme: const DialogTheme().copyWith(
    backgroundColor: const Color.fromARGB(255, 207, 214, 250),
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: const TextStyle().copyWith(
      color: Colors.black,
      fontSize: 16,
    ),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 207, 214, 250),
  colorScheme: kLightColorScheme,
  brightness: Brightness.light,
);
var kDarkThemeData = kLightThemeData.copyWith(
  colorScheme: kDarkColorScheme,
  brightness: Brightness.dark,
);
