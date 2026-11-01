import 'package:flutter/material.dart';
import 'otp_screen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});
  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => OtpScreen(phone: _phone.text.trim())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter your mobile number'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  prefixText: '+91 ',
                  border: OutlineInputBorder(),
                  labelText: 'Mobile number',
                ),
                validator: (v) {
                  final s = (v ?? '').trim();
                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(s)) {
                    return 'Enter a valid 10-digit Indian mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              FilledButton(onPressed: _next, child: const Text('Send OTP')),
              const SizedBox(height: 12),
              const Text('MOCK: no SMS is sent. Real OTP comes with Firebase.'),
            ],
          ),
        ),
      ),
    );
  }
}