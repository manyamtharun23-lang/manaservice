enum BookingStatus {
  requested,
  accepted,
  inProgress,
  completed,
  rejected,
  cancelled,
}

class Booking {
  final String id;
  final String providerId;
  final String providerName;
  final String categoryId;
  final String problem;
  final String address;
  final DateTime scheduledAt;
  final BookingStatus status;
  final DateTime? createdAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final int? rating;

  const Booking({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.categoryId,
    required this.problem,
    required this.address,
    required this.scheduledAt,
    required this.status,
    this.createdAt,
    this.acceptedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.rating,
  });

  Booking copyWith({
    BookingStatus? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    int? rating,
  }) =>
      Booking(
        id: id,
        providerId: providerId,
        providerName: providerName,
        categoryId: categoryId,
        problem: problem,
        address: address,
        scheduledAt: scheduledAt,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        acceptedAt: acceptedAt ?? this.acceptedAt,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt ?? this.completedAt,
        cancelledAt: cancelledAt ?? this.cancelledAt,
        rating: rating ?? this.rating,
      );
}