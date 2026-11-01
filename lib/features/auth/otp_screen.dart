import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otp = TextEditingController();
  String? _error;

  // MOCK ONLY: a fixed code. Never do this in the real app.
  static const _mockCode = '123456';

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  void _verify() {
    if (_otp.text.trim() == _mockCode) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (r) => false,
      );
    } else {
      setState(() => _error = 'Wrong code. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Code sent to +91 ${widget.phone}'),
            const SizedBox(height: 12),
            TextField(
              controller: _otp,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: '6-digit code',
                errorText: _error,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(onPressed: _verify, child: const Text('Verify')),
            const SizedBox(height: 12),
            const Text('MOCK: use code 123456.'),
          ],
        ),
      ),
    );
  }
}