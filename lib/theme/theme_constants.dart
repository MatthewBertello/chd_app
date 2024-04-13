import 'package:flutter/material.dart';

// Light color scheme
ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 251, 144, 255),
);

// Dark color scheme
ColorScheme darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 251, 144, 255),
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
  appBarTheme: appBarTheme(colorScheme: darkColorScheme),
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
