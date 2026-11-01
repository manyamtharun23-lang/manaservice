import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking.dart';
import '../booking/booking_state.dart';
import '../booking/my_bookings_screen.dart' show statusLabel;

class AvailabilityNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void set(bool v) => state = v;
}

final availabilityProvider =
    NotifierProvider<AvailabilityNotifier, bool>(AvailabilityNotifier.new);

class ProviderDashboard extends ConsumerWidget {
  const ProviderDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = ref.watch(availabilityProvider);
    final bookings = ref.watch(bookingsProvider);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
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
                  if (b.status == BookingStatus.requested)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          FilledButton(
                            onPressed: () => ref
                                .read(bookingsProvider.notifier)
                                .setStatus(b.id, BookingStatus.accepted),
                            child: const Text('Accept'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () => ref
                                .read(bookingsProvider.notifier)
                                .setStatus(b.id, BookingStatus.rejected),
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}