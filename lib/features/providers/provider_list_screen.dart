import 'package:flutter/material.dart';
import '../../data/mock/mock_data.dart';
import '../../models/category.dart';
import 'provider_profile_screen.dart';

class ProviderListScreen extends StatelessWidget {
  final ServiceCategory category;
  const ProviderListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final providers =
        mockProviders.where((p) => p.categoryId == category.id).toList();

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: providers.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No providers found yet in this category (MOCK data).',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: providers.length,
              itemBuilder: (context, i) {
                final p = providers[i];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(p.name),
                    subtitle: Text(
                      '${p.rating} (${p.reviewCount} reviews) • '
                      '${p.distanceKm} km\n'
                      '${p.isAvailable ? "Available" : "Unavailable"} • '
                      '${p.isVerified ? "Verified" : "Not verified"}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProviderProfileScreen(provider: p),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}