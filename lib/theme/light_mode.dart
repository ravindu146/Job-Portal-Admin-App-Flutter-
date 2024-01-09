import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade300,
      primary: Colors.grey.shade200,
      secondary: Colors.grey.shade400,
      tertiary: Colors.grey.shade500,
      inversePrimary: Colors.grey.shade800,
    ),
    textTheme: ThemeData.light().textTheme.apply(bodyColor: Colors.black));
