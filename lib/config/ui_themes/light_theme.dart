import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  textTheme: const TextTheme(
    displaySmall: TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.red,
      fontSize: 14,
    ),
  ),
);
