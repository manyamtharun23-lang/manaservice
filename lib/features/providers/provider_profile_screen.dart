import 'package:flutter/material.dart';
import '../../models/provider_profile.dart';

class ProviderProfileScreen extends StatelessWidget {
  final ProviderProfile provider;
  const ProviderProfileScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final p = provider;
    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 32, child: Icon(Icons.person)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name,
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(p.area),
                    Text('${p.rating} (${p.reviewCount} reviews)'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(p.isVerified ? 'Verified' : 'Not verified')),
              Chip(
                  label: Text(p.isAvailable ? 'Available' : 'Unavailable')),
            ],
          ),
          const Divider(height: 32),
          _info('Experience', p.experience),
          _info('Pricing', p.pricing),
          _info('About', p.description),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: p.isAvailable
                ? () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Booking form comes in the next step (MOCK).'),
                      ),
                    )
                : null,
            child: const Text('Book'),
          ),
          if (!p.isAvailable)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('This provider is currently unavailable.'),
            ),
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}