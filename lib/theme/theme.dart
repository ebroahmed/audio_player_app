import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 51, 14, 1)),
  scaffoldBackgroundColor: Colors.white, // important

  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(230, 51, 14, 1),
    titleTextStyle: GoogleFonts.solway(fontSize: 20),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: GoogleFonts.interTextTheme(),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(230, 51, 14, 1),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
);
