// MOCK: kept in memory only.
// Note: there is NO "verified" field here on purpose. Verification must be
// decided by an administrator on the server, never by the app itself.
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PricingModel { fixed, hourly, perVisit, perDay, inspectionQuote }

String pricingLabel(PricingModel m) {
  switch (m) {
    case PricingModel.fixed:
      return 'Fixed price';
    case PricingModel.hourly:
      return 'Hourly rate';
    case PricingModel.perVisit:
      return 'Per-visit fee';
    case PricingModel.perDay:
      return 'Per-day rate';
    case PricingModel.inspectionQuote:
      return 'Inspection, then quotation';
  }
}

class ProviderRegistration {
  final Set<String> categoryIds;
  final String serviceArea;
  final PricingModel pricing;
  final String languages;
  final String experience;

  const ProviderRegistration({
    required this.categoryIds,
    required this.serviceArea,
    required this.pricing,
    required this.languages,
    required this.experience,
  });
}

class RegistrationNotifier extends Notifier<ProviderRegistration?> {
  @override
  ProviderRegistration? build() => null;

  void save(ProviderRegistration r) => state = r;
}

final registrationProvider =
    NotifierProvider<RegistrationNotifier, ProviderRegistration?>(
        RegistrationNotifier.new);