// MOCK DATA: temporary, will be replaced by Firestore later.
// All names, ratings, prices and "verified" flags below are FAKE.
import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../models/provider_profile.dart';

const mockCategories = [
  ServiceCategory('plumbing', 'Plumbing', Icons.plumbing),
  ServiceCategory('electrical', 'Electrical', Icons.electrical_services),
  ServiceCategory('carpentry', 'Carpentry', Icons.handyman),
  ServiceCategory('painting', 'Painting', Icons.format_paint),
  ServiceCategory('mechanic', 'Mechanic', Icons.build),
  ServiceCategory('cleaning', 'Cleaning', Icons.cleaning_services),
  ServiceCategory('veterinary', 'Veterinary', Icons.pets),
  ServiceCategory('medical', 'Medical', Icons.medical_services),
];

const mockProviders = [
  ProviderProfile(
    id: 'p1',
    name: 'Ravi Kumar (MOCK)',
    categoryId: 'plumbing',
    area: 'Village A',
    rating: 4.5,
    reviewCount: 12,
    distanceKm: 1.2,
    isVerified: true,
    isAvailable: true,
    pricing: 'Per visit: Rs 200 (sample)',
    experience: '8 years',
    description: 'Pipe leaks, tap and motor fitting. Sample profile.',
  ),
  ProviderProfile(
    id: 'p2',
    name: 'Suresh (MOCK)',
    categoryId: 'plumbing',
    area: 'Village B',
    rating: 4.0,
    reviewCount: 5,
    distanceKm: 3.5,
    isVerified: false,
    isAvailable: false,
    pricing: 'Inspection, then quotation',
    experience: '3 years',
    description: 'General plumbing work. Sample profile.',
  ),
  ProviderProfile(
    id: 'p3',
    name: 'Anil Electricals (MOCK)',
    categoryId: 'electrical',
    area: 'Town C',
    rating: 4.8,
    reviewCount: 30,
    distanceKm: 2.0,
    isVerified: true,
    isAvailable: true,
    pricing: 'Hourly: Rs 150 (sample)',
    experience: '10 years',
    description: 'Wiring, fan and switchboard repair. Sample profile.',
  ),
  ProviderProfile(
    id: 'p4',
    name: 'Mohan (MOCK)',
    categoryId: 'mechanic',
    area: 'Village A',
    rating: 4.2,
    reviewCount: 9,
    distanceKm: 0.8,
    isVerified: false,
    isAvailable: true,
    pricing: 'Inspection, then quotation',
    experience: '6 years',
    description: 'Motorcycle and scooter repair. Sample profile.',
  ),
];