import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 68, 20, 1),
  ),
  scaffoldBackgroundColor: Colors.white, // important

  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(185, 77, 22, 2),
    titleTextStyle: GoogleFonts.solway(fontSize: 20),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: GoogleFonts.interTextTheme(),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 51, 14, 1),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
);
