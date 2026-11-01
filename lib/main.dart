import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: ManaServiceApp()));
}

class ManaServiceApp extends StatelessWidget {
  const ManaServiceApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManaService',
      theme: buildTheme(),
      home: const SplashScreen(),
    );
  }
}