import 'package:flutter/material.dart';

import '../../data/mock/mock_data.dart';
import '../../models/category.dart';
import 'provider_profile_screen.dart';

class ProviderListScreen extends StatefulWidget {
  final ServiceCategory category;
  const ProviderListScreen({super.key, required this.category});

  @override
  State<ProviderListScreen> createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final providers = mockProviders
        .where((p) => p.categoryId == widget.category.id)
        .where((p) => q.isEmpty || p.area.toLowerCase().contains(q))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on_outlined),
                hintText: 'Filter by village, town or pincode',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: providers.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No providers found for this area (MOCK data).',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: providers.length,
                    itemBuilder: (context, i) {
                      final p = providers[i];
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(p.name),
                          subtitle: Text(
                            '${p.area} • ${p.rating} (${p.reviewCount} reviews) • '
                            '${p.distanceKm} km\n'
                            '${p.isAvailable ? "Available" : "Unavailable"} • '
                            '${p.isVerified ? "Verified" : "Not verified"}',
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProviderProfileScreen(provider: p),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
