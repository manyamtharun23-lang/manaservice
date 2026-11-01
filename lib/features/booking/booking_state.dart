// MOCK: bookings are kept in memory only. They vanish when the app closes.
// Real bookings will be created and validated on the server (Firebase).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking.dart';

class BookingsNotifier extends Notifier<List<Booking>> {
  @override
  List<Booking> build() => [];

  void add(Booking b) => state = [b, ...state];

  // MOCK rule: only a REQUESTED booking can be accepted or rejected.
  // The real version of this check must run on the server.
  void setStatus(String id, BookingStatus newStatus) {
    state = [
      for (final b in state)
        if (b.id == id && b.status == BookingStatus.requested)
          b.copyWith(status: newStatus)
        else
          b,
    ];
  }
}

final bookingsProvider =
    NotifierProvider<BookingsNotifier, List<Booking>>(BookingsNotifier.new);