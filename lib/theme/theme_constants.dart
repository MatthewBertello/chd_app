import 'package:flutter/material.dart';

// Light color scheme
ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 197, 0, 0),
);

// Dark color scheme
ColorScheme darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 84, 19, 90),
  );

// Light theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  appBarTheme: appBarTheme(colorScheme: lightColorScheme),
  buttonTheme: buttonTheme(colorScheme: lightColorScheme),
);

// Dark theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.primary,
    titleTextStyle: TextStyle(
        color: darkColorScheme.onPrimary,
        fontSize: 20.0,
        fontWeight: FontWeight.bold),
  ),

  buttonTheme: buttonTheme(colorScheme: darkColorScheme),
);

// AppBar theme
AppBarTheme appBarTheme({required ColorScheme colorScheme}) {
  return AppBarTheme(
    backgroundColor: colorScheme.primary,
    titleTextStyle: TextStyle(
        color: colorScheme.onPrimary,
        fontSize: 20.0,
        fontWeight: FontWeight.bold),
  );
}

// Button theme
ButtonThemeData buttonTheme({required ColorScheme colorScheme}) {
  return ButtonThemeData(
    buttonColor: colorScheme.secondary,
    textTheme: ButtonTextTheme.primary,
    hoverColor: colorScheme.tertiary,
  );
}