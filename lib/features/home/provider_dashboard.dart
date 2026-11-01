import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock/mock_data.dart';
import '../../models/booking.dart';
import '../booking/booking_state.dart';
import '../booking/my_bookings_screen.dart' show statusLabel;
import '../provider_setup/provider_registration_screen.dart';
import '../provider_setup/provider_registration_state.dart';

class AvailabilityNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void set(bool v) => state = v;
}

final availabilityProvider =
    NotifierProvider<AvailabilityNotifier, bool>(AvailabilityNotifier.new);

class ProviderDashboard extends ConsumerWidget {
  const ProviderDashboard({super.key});

  List<Widget> _actions(WidgetRef ref, Booking b) {
    final n = ref.read(bookingsProvider.notifier);
    switch (b.status) {
      case BookingStatus.requested:
        return [
          FilledButton(
            onPressed: () => n.setStatus(b.id, BookingStatus.accepted),
            child: const Text('Accept'),
          ),
          OutlinedButton(
            onPressed: () => n.setStatus(b.id, BookingStatus.rejected),
            child: const Text('Reject'),
          ),
        ];
      case BookingStatus.accepted:
        return [
          FilledButton(
            onPressed: () => n.setStatus(b.id, BookingStatus.inProgress),
            child: const Text('Start job'),
          ),
        ];
      case BookingStatus.inProgress:
        return [
          FilledButton(
            onPressed: () => n.setStatus(b.id, BookingStatus.completed),
            child: const Text('Mark completed'),
          ),
        ];
      default:
        return const [];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = ref.watch(availabilityProvider);
    final bookings = ref.watch(bookingsProvider);
    final reg = ref.watch(registrationProvider);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.badge),
            title: Text(reg == null
                ? 'Set up your provider profile'
                : 'Your provider profile'),
            subtitle: Text(reg == null
                ? 'Choose your skills, area and pricing.'
                : 'Services: ${mockCategories.where((c) => reg.categoryIds.contains(c.id)).map((c) => c.name).join(", ")}\n'
                    'Area: ${reg.serviceArea}\n'
                    'Verification: Pending review (MOCK)'),
            isThreeLine: reg != null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ProviderRegistrationScreen(),
              ),
            ),
          ),
        ),
        Card(
          child: SwitchListTile(
            title: const Text('Available for new requests'),
            subtitle: Text(available ? 'Available' : 'Unavailable'),
            value: available,
            onChanged: (v) => ref.read(availabilityProvider.notifier).set(v),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(4, 12, 4, 4),
          child: Text(
            'MOCK: this shows all requests made in this app, as if they were sent to you.',
          ),
        ),
        const SizedBox(height: 8),
        if (bookings.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No requests yet.')),
          ),
        for (final b in bookings)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.providerName,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(b.problem),
                  Text('Address: ${b.address}'),
                  Text(
                      'When: ${b.scheduledAt.day}/${b.scheduledAt.month}/${b.scheduledAt.year} '
                      '${TimeOfDay.fromDateTime(b.scheduledAt).format(context)}'),
                  Text('Status: ${statusLabel(b.status)}'),
                  if (b.rating != null) Text('Customer rating: ${b.rating} / 5'),
                  Builder(builder: (context) {
                    final actions = _actions(ref, b);
                    if (actions.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Wrap(spacing: 8, children: actions),
                    );
                  }),
                ],
              ),
            ),
          ),
      ],
    );
  }
}