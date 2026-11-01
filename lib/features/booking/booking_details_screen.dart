import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking.dart';
import 'booking_state.dart';
import 'my_bookings_screen.dart' show statusLabel;

class BookingDetailsScreen extends ConsumerWidget {
  final String bookingId;
  const BookingDetailsScreen({super.key, required this.bookingId});

  String _fmt(BuildContext context, DateTime? d) {
    if (d == null) return '-';
    return '${d.day}/${d.month}/${d.year} '
        '${TimeOfDay.fromDateTime(d).format(context)}';
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value),
          ],
        ),
      );

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel this booking?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep booking'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (ok == true) {
      ref
          .read(bookingsProvider.notifier)
          .setStatus(bookingId, BookingStatus.cancelled);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches =
        ref.watch(bookingsProvider).where((x) => x.id == bookingId);
    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking')),
        body: const Center(child: Text('Booking not found.')),
      );
    }
    final b = matches.first;
    final canCancel = allowedTransitions[b.status]!
        .contains(BookingStatus.cancelled);
    final canRate =
        b.status == BookingStatus.completed && b.rating == null;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _row('Booking ID', b.id),
          _row('Provider', b.providerName),
          _row('Problem', b.problem),
          _row('Service address', b.address),
          _row('Appointment', _fmt(context, b.scheduledAt)),
          _row('Status', statusLabel(b.status)),
          const Divider(height: 32),
          _row('Requested at', _fmt(context, b.createdAt)),
          _row('Accepted at', _fmt(context, b.acceptedAt)),
          _row('Started at', _fmt(context, b.startedAt)),
          _row('Completed at', _fmt(context, b.completedAt)),
          _row('Cancelled at', _fmt(context, b.cancelledAt)),
          const SizedBox(height: 8),
          if (canCancel)
            OutlinedButton(
              onPressed: () => _confirmCancel(context, ref),
              child: const Text('Cancel booking'),
            ),
          if (canRate) ...[
            const SizedBox(height: 16),
            const Text('How was the service? Tap a star.'),
            Row(
              children: [
                for (var s = 1; s <= 5; s++)
                  IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () =>
                        ref.read(bookingsProvider.notifier).rate(b.id, s),
                  ),
              ],
            ),
          ],
          if (b.rating != null)
            Text('Your rating: ${b.rating} / 5'),
          const SizedBox(height: 16),
          const Text('MOCK: stored in memory only.'),
        ],
      ),
    );
  }
}