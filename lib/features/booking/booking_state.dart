// MOCK: bookings are kept in memory only. They vanish when the app closes.
// Real bookings will be created and validated on the server (Firebase).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking.dart';

class BookingsNotifier extends Notifier<List<Booking>> {
  @override
  List<Booking> build() => [];

  void add(Booking b) => state = [b, ...state];
}

final bookingsProvider =
    NotifierProvider<BookingsNotifier, List<Booking>>(BookingsNotifier.new);