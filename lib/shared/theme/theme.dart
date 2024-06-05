import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
  textTheme: GoogleFonts.openSansTextTheme(
    ThemeData.light().textTheme,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    fillColor: Colors.grey.shade200,
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade300,
    thickness: 0.5,
    space: 0,
  ),
  appBarTheme: const AppBarTheme(centerTitle: true),
  chipTheme: ChipThemeData(
    side: BorderSide(color: Colors.grey.shade300),
    shape: const StadiumBorder(),
  ),
);

final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.cyan, brightness: Brightness.dark),
    textTheme: GoogleFonts.openSansTextTheme(
      ThemeData.dark().textTheme,
    ),
    inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
      fillColor: Colors.grey.shade800,
    ),
    dividerTheme: lightTheme.dividerTheme.copyWith(
      color: Colors.grey.shade800,
    ),
    appBarTheme: lightTheme.appBarTheme,
    chipTheme: lightTheme.chipTheme.copyWith(
      side: BorderSide(color: Colors.grey.shade800),
      backgroundColor: Colors.grey.shade800,
    ));
