class ProviderProfile {
  final String id;
  final String name;
  final String categoryId;
  final String area;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final bool isVerified;
  final bool isAvailable;
  final String pricing;
  final String experience;
  final String description;

  const ProviderProfile({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.area,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.isVerified,
    required this.isAvailable,
    required this.pricing,
    required this.experience,
    required this.description,
  });
}