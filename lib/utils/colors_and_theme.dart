import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kLightColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 207, 214, 250));
var kDarkColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 226, 247, 235));

var kLightThemeData = ThemeData().copyWith(
  colorScheme: kLightColorScheme,
  brightness: Brightness.light,
  textTheme: GoogleFonts.poppinsTextTheme()
);
var kDarkThemeData = kLightThemeData.copyWith(
  colorScheme: kDarkColorScheme,
  brightness: Brightness.dark,
);


Map<String, int> kWordThemePack = {
  'WORD_CARD': 0xFFFAFBFD,
  'backGround': 0xFFFAFBFD,//cream
  'A': 0xFF5D63DE,
  'B': 0xFFE64A80,
  'C': 0xFF,
  'D': 0xFF63C4D0,
  'E': 0xFF6619,
  'F': 0xFFFA7F82,
  'G': 0xFFE833D9,
  'H': 0xFF9251E0,
  'I': 0xFFFD8766,
  'J': 0xFFFF9B00,
  'K': 0xFF3a6cd3,
  'L': 0xFF,
  'M': 0xFF95D8F9,
  'N': 0xFF,
  'O': 0xFF806ec2,
  'P': 0xFF,
  'Q': 0xFF456DA7,
  'R': 0xFF,
  'S': 0xFF3CC3AA,
  'T': 0xFFeb8efd,
  'U': 0xFF,
  'V': 0xFf,
  'W': 0xFF38BBB2,
  'X': 0xFFA481FB,
  'Y': 0xFFFF697A,
  'Z': 0xFFFFAE59,
};

getColorForWord(String w) {
  return kWordThemePack[w.toUpperCase()] ?? 0xFF000000; // Default to black if key is missing

}