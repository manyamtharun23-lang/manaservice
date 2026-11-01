import 'package:flutter/material.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: c.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.handyman, size: 80, color: c.onPrimary),
            const SizedBox(height: 16),
            Text('ManaService',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: c.onPrimary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('One App. Two Modes. Local Services Made Easy.',
                textAlign: TextAlign.center,
                style: TextStyle(color: c.onPrimary)),
          ],
        ),
      ),
    );
  }
}