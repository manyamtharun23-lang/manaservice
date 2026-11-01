import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaservice/features/booking/booking_state.dart';
import 'package:manaservice/models/booking.dart';

Booking _sample() => Booking(
      id: 'b1',
      providerId: 'p1',
      providerName: 'Test provider',
      categoryId: 'plumbing',
      problem: 'Leaking pipe',
      address: 'Main street',
      scheduledAt: DateTime(2030, 1, 1, 10, 0),
      status: BookingStatus.requested,
    );

void main() {
  late ProviderContainer container;
  late BookingsNotifier n;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
    n = container.read(bookingsProvider.notifier);
    n.add(_sample());
  });

  BookingStatus status() => container.read(bookingsProvider).first.status;

  test('cannot complete a booking that was never accepted', () {
    expect(n.setStatus('b1', BookingStatus.completed), isFalse);
    expect(status(), BookingStatus.requested);
  });

  test('normal path works in order', () {
    expect(n.setStatus('b1', BookingStatus.accepted), isTrue);
    expect(n.setStatus('b1', BookingStatus.inProgress), isTrue);
    expect(n.setStatus('b1', BookingStatus.completed), isTrue);
    expect(status(), BookingStatus.completed);
  });

  test('rejected booking cannot become accepted', () {
    expect(n.setStatus('b1', BookingStatus.rejected), isTrue);
    expect(n.setStatus('b1', BookingStatus.accepted), isFalse);
    expect(status(), BookingStatus.rejected);
  });

  test('completed booking cannot be cancelled or reopened', () {
    n.setStatus('b1', BookingStatus.accepted);
    n.setStatus('b1', BookingStatus.inProgress);
    n.setStatus('b1', BookingStatus.completed);
    expect(n.setStatus('b1', BookingStatus.cancelled), isFalse);
    expect(n.setStatus('b1', BookingStatus.requested), isFalse);
  });

  test('rating only after completion, and only once', () {
    expect(n.rate('b1', 5), isFalse);
    n.setStatus('b1', BookingStatus.accepted);
    n.setStatus('b1', BookingStatus.inProgress);
    n.setStatus('b1', BookingStatus.completed);
    expect(n.rate('b1', 6), isFalse);
    expect(n.rate('b1', 4), isTrue);
    expect(n.rate('b1', 5), isFalse);
    expect(container.read(bookingsProvider).first.rating, 4);
  });
}