enum BookingStatus { requested, accepted, rejected, cancelled }

class Booking {
  final String id;
  final String providerId;
  final String providerName;
  final String categoryId;
  final String problem;
  final String address;
  final DateTime scheduledAt;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.categoryId,
    required this.problem,
    required this.address,
    required this.scheduledAt,
    required this.status,
  });

  Booking copyWith({BookingStatus? status}) => Booking(
        id: id,
        providerId: providerId,
        providerName: providerName,
        categoryId: categoryId,
        problem: problem,
        address: address,
        scheduledAt: scheduledAt,
        status: status ?? this.status,
      );
}