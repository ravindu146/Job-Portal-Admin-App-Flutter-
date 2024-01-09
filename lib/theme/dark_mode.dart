import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.grey.shade900,
      primary: Colors.grey.shade900,
      secondary: Colors.grey.shade700,
      tertiary: Colors.grey.shade500,
      inversePrimary: Colors.grey.shade300,
    ),
    textTheme: ThemeData.dark().textTheme.apply(bodyColor: Colors.white));
