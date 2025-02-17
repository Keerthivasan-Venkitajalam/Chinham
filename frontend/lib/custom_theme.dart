import 'package:flutter/material.dart';

// Use to store local theme data temporarily
late ThemeData currentTheme;

// Custom Green for app
Map<int, Color> primary = {
  50: const Color.fromRGBO(17, 138, 126, .1),
  100: const Color.fromRGBO(17, 138, 126, .2),
  200: const Color.fromRGBO(17, 138, 126, .3),
  300: const Color.fromRGBO(17, 138, 126, .4),
  400: const Color.fromRGBO(17, 138, 126, .5),
  500: const Color.fromRGBO(17, 138, 126, .6),
  600: const Color.fromRGBO(17, 138, 126, .7),
  700: const Color.fromRGBO(17, 138, 126, .8),
  800: const Color.fromRGBO(17, 138, 126, .9),
  900: const Color.fromRGBO(17, 138, 126, 1),
};

// Main theme color
final defaultColor = MaterialColor(0xFF118A7E, primary);

// Generate custom theme
ThemeData createThemeData(MaterialColor color, bool isDark, double fontSize) {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: color,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: color,
      foregroundColor: isDark ? Colors.black : Colors.white,
    ),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: fontSize),
      bodyMedium: TextStyle(fontSize: fontSize),
      labelLarge: TextStyle(fontSize: fontSize),
      displayLarge: TextStyle(fontSize: fontSize),
      displayMedium: TextStyle(fontSize: fontSize),
      displaySmall: TextStyle(fontSize: fontSize),
      headlineLarge: TextStyle(fontSize: fontSize),
      headlineMedium: TextStyle(fontSize: fontSize),
      headlineSmall: TextStyle(fontSize: fontSize),
    ),
  );
}
