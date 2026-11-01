import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock/mock_data.dart';
import '../booking/my_bookings_screen.dart';
import '../providers/provider_list_screen.dart';
import 'provider_dashboard.dart';

enum AppMode { customer, provider }

class ModeNotifier extends Notifier<AppMode> {
  @override
  AppMode build() => AppMode.customer;
  void set(AppMode m) => state = m;
}

final modeProvider =
    NotifierProvider<ModeNotifier, AppMode>(ModeNotifier.new);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCustomer = ref.watch(modeProvider) == AppMode.customer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ManaService'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'My bookings',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
            ),
          ),
          Text(isCustomer ? 'Customer' : 'Provider'),
          Switch(
            value: !isCustomer,
            onChanged: (v) => ref
                .read(modeProvider.notifier)
                .set(v ? AppMode.provider : AppMode.customer),
          ),
        ],
      ),
      body: isCustomer ? const _CustomerHome() : const ProviderDashboard(),
    );
  }
}

class _CustomerHome extends StatelessWidget {
  const _CustomerHome();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search services',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text('Service categories',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                for (final c in mockCategories)
                  Card(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProviderListScreen(category: c),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(c.icon, size: 36),
                          const SizedBox(height: 8),
                          Text(c.name),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}