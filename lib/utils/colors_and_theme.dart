import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kLightColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 207, 214, 250));
var kDarkColorScheme = kLightColorScheme;
    // ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 226, 247, 235));

var kLightThemeData = ThemeData().copyWith(
  colorScheme: kLightColorScheme,
  brightness: Brightness.light,
  textTheme: GoogleFonts.poppinsTextTheme(),
  cardTheme: const CardTheme().copyWith(
    color: ThemeData().focusColor,
  )
);
var kDarkThemeData = kLightThemeData.copyWith(
  colorScheme: kDarkColorScheme,
  brightness: Brightness.dark,
);
