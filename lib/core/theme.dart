import 'package:flutter/material.dart';

ThemeData buildTheme() {
  const seed = Color(0xFF1B7F5C);
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seed),
    useMaterial3: true,
  );
}