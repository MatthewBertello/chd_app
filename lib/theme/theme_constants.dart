import 'package:flutter/material.dart';

// Light color scheme
ColorScheme lightColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color.fromARGB(255, 251, 144, 255),
  onPrimaryContainer: Colors.black,
  secondary: const Color.fromARGB(255, 65, 16, 105),
  onSecondaryContainer: Colors.black,
  tertiary: const Color.fromARGB(255, 6, 95, 155),
  onTertiary: Colors.white,
  tertiaryContainer: const Color.fromARGB(255, 63, 171, 243),
  onTertiaryContainer: Colors.black,
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
  inputDecorationTheme: inputDecorationTheme(colorScheme: lightColorScheme),
);

// Dark theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  appBarTheme: appBarTheme(colorScheme: darkColorScheme),
  buttonTheme: buttonTheme(colorScheme: darkColorScheme),
  inputDecorationTheme: inputDecorationTheme(colorScheme: darkColorScheme),
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
  );
}

// Input decoration theme
InputDecorationTheme inputDecorationTheme({required ColorScheme colorScheme}) {
  return InputDecorationTheme(
    filled: true,
    fillColor: colorScheme.surface,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.tertiary,
      ),
    ),
  );
}