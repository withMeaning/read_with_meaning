import 'package:flutter/material.dart';

// TODO rename to Theme
// and actually build a propper theme here
// three themes: light, dark, and dark with high contrast
// with persistent storage an option to set the theme

const Color primaryColor = Colors.red;
const Color secondayColor = Colors.black;
const Color backgroundColor = Colors.white;

const Color darkPrimaryColor = Color(0xffDB7211);
const Color darkSecondayColor = Color(0xffADBB16);
const Color darkBackgroundColor = Color(0xff151312);
const Color darkSurfaceColor = Color(0xff1F1C1B);
const Color darkBlack = Colors.black;
//const Color darkBackgroundColor = Colors.black;

class MeaningAppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor, brightness: Brightness.light),
    useMaterial3: true,
  );
  static final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.highContrastDark(
        brightness: Brightness.dark,
        primary: darkPrimaryColor,
        secondary: darkPrimaryColor,
        background: darkBackgroundColor,
        surface: darkSurfaceColor,
        surfaceVariant: darkBlack,
      ),
      useMaterial3: true,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 18.0),
        bodySmall: TextStyle(fontSize: 14.0),
        titleMedium: TextStyle(fontSize: 22.0),
      ));
}
