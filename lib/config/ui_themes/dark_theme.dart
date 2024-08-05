import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.indigo,
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    displaySmall: TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.yellow,
      fontSize: 20,
    ),
  ),
);
