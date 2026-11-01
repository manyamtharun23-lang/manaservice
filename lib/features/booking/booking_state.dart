// MOCK: bookings are kept in memory only. They vanish when the app closes.
// The rules below must be enforced again on the server (Firebase) later,
// because a phone app can never be trusted to enforce them.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking.dart';

const Map<BookingStatus, Set<BookingStatus>> allowedTransitions = {
  BookingStatus.requested: {
    BookingStatus.accepted,
    BookingStatus.rejected,
    BookingStatus.cancelled,
  },
  BookingStatus.accepted: {
    BookingStatus.inProgress,
    BookingStatus.cancelled,
  },
  BookingStatus.inProgress: {BookingStatus.completed},
  BookingStatus.completed: {},
  BookingStatus.rejected: {},
  BookingStatus.cancelled: {},
};

class BookingsNotifier extends Notifier<List<Booking>> {
  @override
  List<Booking> build() => [];

  void add(Booking b) {
    final withTime = b.createdAt == null
        ? b.copyWith(createdAt: DateTime.now())
        : b;
    state = [withTime, ...state];
  }

  /// Returns true if the change was allowed and applied.
  bool setStatus(String id, BookingStatus next) {
    final i = state.indexWhere((b) => b.id == id);
    if (i < 0) return false;
    final b = state[i];
    if (!(allowedTransitions[b.status]?.contains(next) ?? false)) {
      return false;
    }
    final now = DateTime.now();
    final updated = b.copyWith(
      status: next,
      acceptedAt: next == BookingStatus.accepted ? now : null,
      startedAt: next == BookingStatus.inProgress ? now : null,
      completedAt: next == BookingStatus.completed ? now : null,
      cancelledAt: next == BookingStatus.cancelled ? now : null,
    );
    state = [...state.sublist(0, i), updated, ...state.sublist(i + 1)];
    return true;
  }

  /// A rating is allowed only once, and only after the job is completed.
  bool rate(String id, int stars) {
    if (stars < 1 || stars > 5) return false;
    final i = state.indexWhere((b) => b.id == id);
    if (i < 0) return false;
    final b = state[i];
    if (b.status != BookingStatus.completed || b.rating != null) {
      return false;
    }
    state = [
      ...state.sublist(0, i),
      b.copyWith(rating: stars),
      ...state.sublist(i + 1),
    ];
    return true;
  }
}

final bookingsProvider =
    NotifierProvider<BookingsNotifier, List<Booking>>(BookingsNotifier.new);