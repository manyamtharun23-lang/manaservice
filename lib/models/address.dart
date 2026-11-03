class ServiceAddress {
  final String line;
  final String village;
  final String district;
  final String state;
  final String pincode;
  final double? latitude;
  final double? longitude;

  const ServiceAddress({
    required this.line,
    required this.village,
    required this.district,
    required this.state,
    required this.pincode,
    this.latitude,
    this.longitude,
  });

  String get oneLine => '$line, $village, $district, $state - $pincode';
}

const indianStates = [
  'Andhra Pradesh',
  'Arunachal Pradesh',
  'Assam',
  'Bihar',
  'Chhattisgarh',
  'Goa',
  'Gujarat',
  'Haryana',
  'Himachal Pradesh',
  'Jharkhand',
  'Karnataka',
  'Kerala',
  'Madhya Pradesh',
  'Maharashtra',
  'Manipur',
  'Meghalaya',
  'Mizoram',
  'Nagaland',
  'Odisha',
  'Punjab',
  'Rajasthan',
  'Sikkim',
  'Tamil Nadu',
  'Telangana',
  'Tripura',
  'Uttar Pradesh',
  'Uttarakhand',
  'West Bengal',
  'Andaman and Nicobar Islands',
  'Chandigarh',
  'Dadra and Nagar Haveli and Daman and Diu',
  'Delhi',
  'Jammu and Kashmir',
  'Ladakh',
  'Lakshadweep',
  'Puducherry',
];

bool isValidPincode(String s) => RegExp(r'^[1-9]\d{5}$').hasMatch(s.trim());
