import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constant.dart';

class AppTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.inika(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.itim(
      color: Colors.black,
      fontSize: 20,
    ),
    displaySmall: GoogleFonts.inika(
      color: Colors.black,
      fontSize: 16,
    ),
    headlineSmall: GoogleFonts.inika(
      color: Colors.black,
      fontSize: 12,
    ),
    headlineMedium: GoogleFonts.itim(
      color: Colors.black,
      fontSize: 16,
    ),
  );
  static ThemeData lightTheme() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: const MaterialColor(
        0xffBC1112,
        <int, Color>{
          50: Color.fromRGBO(236, 49, 51, .1),
          100: Color.fromRGBO(236, 49, 51, .2),
          200: Color.fromRGBO(236, 49, 51, .3),
          300: Color.fromRGBO(236, 49, 51, .4),
          400: Color.fromRGBO(236, 49, 51, .5),
          500: Color.fromRGBO(236, 49, 51, .6),
          600: Color.fromRGBO(236, 49, 51, .7),
          700: Color.fromRGBO(236, 49, 51, .8),
          800: Color.fromRGBO(236, 49, 51, .9),
          900: Color.fromRGBO(236, 49, 51, 1),
        },
      ),
      brightness: Brightness.light,
      textTheme: lightTextTheme,
      iconTheme: const IconThemeData(color: Colors.black),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      cardTheme: const CardTheme(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffBC1112),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Dark Theme
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.inika(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.itim(
      color: Colors.white,
      fontSize: 20,
    ),
    displaySmall: GoogleFonts.inika(
      color: Colors.white,
      fontSize: 16,
    ),
    headlineSmall: GoogleFonts.inika(
      color: Colors.white,
      fontSize: 12,
    ),
    headlineMedium: GoogleFonts.itim(
      color: Colors.white,
      fontSize: 16,
    ),
  );
  static ThemeData darkTheme() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.black,
      primarySwatch: const MaterialColor(
        0xffBC1112,
        <int, Color>{
          50: Color.fromRGBO(236, 49, 51, .1),
          100: Color.fromRGBO(236, 49, 51, .2),
          200: Color.fromRGBO(236, 49, 51, .3),
          300: Color.fromRGBO(236, 49, 51, .4),
          400: Color.fromRGBO(236, 49, 51, .5),
          500: Color.fromRGBO(236, 49, 51, .6),
          600: Color.fromRGBO(236, 49, 51, .7),
          700: Color.fromRGBO(236, 49, 51, .8),
          800: Color.fromRGBO(236, 49, 51, .9),
          900: Color.fromRGBO(236, 49, 51, 1),
        },
      ),
      brightness: Brightness.light,
      textTheme: darkTextTheme,
      iconTheme: const IconThemeData(color: Colors.white),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      cardTheme: const CardTheme(
        color: darkThemeCardColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffBC1112),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
