import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking.dart';
import 'booking_details_screen.dart';
import 'booking_state.dart';

String statusLabel(BookingStatus s) {
  switch (s) {
    case BookingStatus.requested:
      return 'REQUESTED (waiting for provider)';
    case BookingStatus.accepted:
      return 'ACCEPTED';
    case BookingStatus.inProgress:
      return 'IN PROGRESS';
    case BookingStatus.completed:
      return 'COMPLETED';
    case BookingStatus.rejected:
      return 'REJECTED';
    case BookingStatus.cancelled:
      return 'CANCELLED';
  }
}

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My bookings')),
      body: bookings.isEmpty
          ? const Center(child: Text('No bookings yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: bookings.length,
              itemBuilder: (context, i) {
                final b = bookings[i];
                final t = b.scheduledAt;
                return Card(
                  child: ListTile(
                    title: Text(b.providerName),
                    subtitle: Text(
                      '${b.problem}\n'
                      '${t.day}/${t.month}/${t.year} '
                      '${TimeOfDay.fromDateTime(t).format(context)}\n'
                      'Status: ${statusLabel(b.status)}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            BookingDetailsScreen(bookingId: b.id),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}